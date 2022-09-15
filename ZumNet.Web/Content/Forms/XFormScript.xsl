<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>

<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">

  <msxsl:script language="javascript" implements-prefix="phxsl">
    <![CDATA[ 
  var m_log="LOG=";
  var m_root = "", m_company = "", m_partid = "", m_bizrole = "", m_actrole = "", m_wid = "";
  var XF = {};
  var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];
  function init(r, c, j, p, b, a, w){m_root=r;m_company=c;eval(j);XF=json; if(p){m_partid=p;}; if(p){m_bizrole=b;}; if(p){m_actrole=a;}; if(w){m_wid=w;}; log(m_partid + " : " + m_bizrole + " : " + m_actrole + " : " + m_wid); return "";}
  function log(v){m_log+=" #"+v;}
  function getLog(){return m_log;}
  function modLevel(m, ds, part, cr, cur, n) {//2014-07-11 수정등급 : 보류인 경우 작성자(A), 지정반려 받은 결재자(B), 그외(N)
    if (n.length > 0 && m=="read" && ds!="700" && ds!="800" && ds!="840") {
      var c = n[0].selectNodes("line[@partid='" + cur + "' and @state=2 and @viewstate=3 and @designator!='']");
      if (c.length>0 && part==cur) return 'B';
      else {
        c = n[0].selectNodes("line[@partid!='' and @state=2 and @viewstate=3 and @signstatus=3]");
        if (c.length>0 && cr==cur) return 'A'; else return 'N';
      }
    } else return "N";
  }

  function enApos(s) {return s.replace(/'/gi, "\\\'");};
  function replaceTextArea(s) {return s.replace(/</gi, "&lt;").replace(/>/gi, "&gt;").replace(/\n/gi,"<br/>").replace(/ /gi, "&nbsp;").replace(/\"/gi, "&quot;").replace(/\'/gi, "&#39;");}
  function encodeHtml(s) {return replaceTextArea(isEmpty(s))}
  function nodeText(n, q) { var f = n[0].selectSingleNode(q), b = (arguments[2]) ? true : false; if (f) {return (b == true) ? replaceTextArea(isEmpty(f.text)) : f.text;} else {return (b == true) ? '&nbsp;' : ''}}
  function strAlt(s) {return s.replace(/</gi, "&lt;").replace(/>/gi, "&gt;").replace(/\"/gi, "&quot;").replace(/\'/gi, "&#39;");}
  function isGroup(type) {return (type.charAt(0) == '' || type.charAt(0) != 'u') ? true : false; }
  function isEmpty(s) {return (s.replace(/ /gi, '') == '') ? "&nbsp;" : s;}
  function isEqual(x, y) {log(x==y); return (x == y) ? true : false;}
  function isDiff(x, y) {log(x!=y); return (x != y) ? true : false;}
  function isExist(x, y) {return (x.indexOf(y)!=-1) ? true : false;}
  function isGt(x, y) {if(!x || x=='') {x=0;} else {x=parseInt(x);}if(!y || y=='') {y=0;} else {y=parseInt(y);} if(x>y){return true;}else{return false;}}
    function down(w, r, x, s) {
        if (w && w != '' && r && r != '') return "https://" + w + "/" + r + "/PortalService/FileDown.aspx?xf=" + x + "&sn=" + escape(s);
	    else return "/BizForce/PortalService/FileDown.aspx?xf=" + x + "&sn=" + escape(s);
    }
    function down2(w, r, v, s, f) {
        if (w && w != '' && r && r != '') return "https://" + w + "/" + r + "/PortalService/FileDown.aspx?fp=" + escape(v + "/" + s) + "&fn=" + escape(f);
	    else return "/BizForce/PortalService/FileDown.aspx?fp=" + escape(v + "/" + s) + "&fn=" + escape(f);
    }
	function getAttachId(f, sn) {
	    if (f && f.length > 0) {
		    for(var i = 0; i < f.length; i++) {
			    if (f[i].selectSingleNode("savedname").text == sn) { return f[i].getAttribute("attachid"); }
			}
		}
		return '';
	}
  function fileDown(w, r, v, s, f) {return "https://" + w + "/" + r + "/PortalService/FileDown.aspx?xf=ea&sn=" + escape(s);}  
  function linkDown(w, r, v, f) {return "https://" + w + "/" + r + "/PortalService/FileDown.aspx?fp=" + escape(v) + "&fn=" + escape(f);}
  function linkDown2(w, r, t, p) {if (t == "pdmpd") {return "https://" + w + "/" + r + "/SSOpdm.aspx?target=prodview&oid=" + p;}else{return '';}}
  //function linkForm(w, r, m) {return "https://" + w + "/" + r + "/EA/Forms/XFormMain.aspx?M=read&mi=" + m;}
  function linkForm(w, r, m) {return "_zw.fn.openEAFormSimple('" + m + "')";}
  function cvtMonth(s) {if(s.length > 1 && s.toString().charAt(0) == '0'){return s.charAt(1);} else {return s;}}
  function rate(c, p, n) {if (c=="" || c=="0" || p=="" || p=="0") {return "&nbsp;"} else {return (parseFloat(c)/parseFloat(p)*100).toFixed(n);}}
  function rate2(c, p, n) {if (c=="" || c=="0" || p=="" || p=="0") {return "&nbsp;"} else {return "$" + addComma(c) + "<br />(" + (parseFloat(c)/parseFloat(p)*100).toFixed(n) + ")";}}
  function isDate(d) {return (d != "" && parseInt(d.substr(0,4)) > 1900) ? true : false;}
  function markingJuminNo(s) {if (s && s!='') {return s.substring(0,6) + " - " + "*******";} else {return "&nbsp;";}}
  function cvtDate(d1, d2, t, n, escaope) {
    var d = (isDate(d1)) ? d1 : d2;
    if (d != "") {//log("d->" + d1 + " : " + d2);
      n = n || 10; //if (!n || n==0) n = 10;
      if (!t || t=='') return d.substr(0, n);
      else if (t=='.') return d.substr(0, n).replace(/-/gi, '. ');
      else if (t=='/') return d.substr(0, n).replace(/-/gi, '/');
      else return (escaope) ? "" : "&nbsp;";
    }
    return (escaope) ? "" : "&nbsp;";
  }
  function convertDate(date) {
	  var szReturn = "&nbsp;";
	  if (date != "") {
		  if (arguments.length > 1) {
			  if (arguments[1] == '.') szReturn = date.substring(0, 10).replace(/-/gi, '. ');
        else if (arguments[1] == 'ko') szReturn = date.substr(0, 4) + "년 " + date.substr(5, 2) + "월 " + date.substr(8, 2) + "일";
        else if (arguments[1] == 'en') szReturn =   monthNames[date.substr(5, 2)-1]+" "+date.substr(8, 2)+", "+ date.substr(0, 4) ;
			  else szReturn = date.substring(0, 10);
		  } else {
			  szReturn = date.substring(0, 8).replace(/-/gi, '/');
		  }
	  }
	  return szReturn;
  }
  function optionYear(cy, sy) {
    var szReturn = '';
	for (var i = cy; i >= sy; i--) {
	    if (i == cy) szReturn += '<option value="' + i.toString() + '" selected="selected">' + i.toString() + '</option>';
        else szReturn += '<option value="' + i.toString() + '">' + i.toString() + '</option>';
	}
	return szReturn;
  }
  function optionYear2(s, e, cy) {log(s + "==" + e + "==" + cy);
    var szReturn = '';
	for (var i = e; i >= s; i--) {
	    if (i == cy) szReturn += '<option value="' + i.toString() + '" selected="selected">' + i.toString() + '</option>';
        else szReturn += '<option value="' + i.toString() + '">' + i.toString() + '</option>';
	}
	//log("~~~~" + szReturn)
	return szReturn;
  }
  function optionMonth(vlu) {
    var szReturn = '';
	for (var i = 1; i <= 12; i++) {
	    if (i == vlu) szReturn += '<option value="' + i.toString() + '" selected="selected">' + i.toString() + '</option>';
        else szReturn += '<option value="' + i.toString() + '">' + i.toString() + '</option>';
	}
	return szReturn;
  }
  function addComma(s) {
    var r=''
    if (s.length > 3) {
      var t1 = s.substring(0, s.length % 3); var t2 = s.substring(s.length % 3, s.length);
	    if (t1.length != 0) {t1 += ',';} r += t1;
	    for (var i=0; i<t2.length; i++) {if (i % 3 == 0 && i != 0 ) {r += ',';} r += t2.charAt(i);}
    } else {
      r = s;
    }
    return isEmpty(r); 
  }
  function addCommaAndDotMinus(s,n) {
    var n = n || 4;
    var isMinus = "", v = s.toString().replace(/,|\s+/g,''); 
    if(v !='' && v.substring(0, 1) == "-") {isMinus = "-"; v = v.substring(1, v.length+1);}
    var bv = (v.indexOf('.') != -1)? v.substring(0,v.indexOf ('.')) :v ; 
    var av = (v.indexOf('.') != -1)? v.substr(v.indexOf ('.'),n+1) : '' ;
    if (s != "NaN" && isNaN(v)) {return "";}
    var last = bv.length-1, a = new Array, cma = ''; 
    for(var i=last,j=0; i >= 0; i--,j++) {cma = (j !=0 && j%3 == 0) ? ',' : ''; a[a.length] = bv.charAt(i) + cma;}
    s = a.reverse().join('') + av; 
    return isMinus + s;
  }
  function nZero(s) {
      var n = (s.indexOf('.') != -1) ? s.substr(0,s.indexOf('.')) : s;
      var f = (s.indexOf('.') != -1) ? s.substr(s.indexOf('.')) : '';
      if (f != '') {
	      for(var i=f.length-1; i>=0;i--) {if (f.charAt(i) != "0") break;}
	      f = f.substr(0, i+1); if (f=='.') f = '';
	  }
	  return isEmpty(n + f);
  }
	
  function insertMiddleHTML(node) {
  //alert(node.xml)
	  var szHTML = "";
	  if (node.getAttribute("state") == "7") {
		  if (node.getAttribute("signstatus") == "8" || node.getAttribute("signstatus") == "10") szHTML = XF.parse.signStatus(8) + "<br />";
		  else szHTML = getSignImage(node)
	  } else {
		  szHTML = "";
	  }
	  if (node.getAttribute("signkind") != "" && node.getAttribute("signkind") != "0" && node.getAttribute("signkind") != "5") //2014-04-10 선결표시 품 && node.getAttribute("signkind") != "6")
		  szHTML += "<br />" + XF.parse.signKind(node.getAttribute("signkind"));
	  //if (node.getAttribute("signstatus") == "6") szHTML += "<br />" + XF.parse.signStatus(node.getAttribute("signstatus")); //2015-02-09 조건부승인 표기
    szHTML += "<br />";
    
    //log(node.getAttribute("state") + " => " + node.getAttribute("partid") + " : " + m_partid + ":::")
    if (node.getAttribute("state") == "2" && node.getAttribute("partid") == m_partid && node.getAttribute("actrole") != "__r" && node.getAttribute("actrole") != "_redrafter" && node.getAttribute("actrole") != "_manager") szHTML += linkPlate(node.selectSingleNode("partname").text);
	  else szHTML += linkPersonInfo('ekp.cresyn.com', m_root, node.selectSingleNode("partname").text, node.getAttribute("partid"), node.selectSingleNode("part2").text);
    
    //if (node.getAttribute("state") == "2") {
    //  if (node.getAttribute("signstatus") == "3") szHTML += "<br /><br />" + XF.parse.signStatus(3);
    //  else szHTML += "<br /><br />대기";
    //} else if (node.getAttribute("state") == "4") szHTML += "<br /><br />결재중";
	  return szHTML;
  }
  function insertBottomHTML(node) {
    var szHTML = '';
    //2011-12-29(12/19 처음작업) 동서에서 날짜에 첨언 표시 (2012-05-17 보류 표시)
    var szComment = ((node.getAttribute("state") == '2' || node.getAttribute("state") == '3') && (node.getAttribute("state") == '2' && node.getAttribute("signstatus") != '3')) ? "" : node.selectSingleNode("comment").text;
    //if (node.getAttribute("state") == '0' && node.getAttribute("signkind") == '6') szComment = ''; //2014-02-20 선결 첨언 안보이게 -> 2014-04-10 품
    if (szComment.replace(/ /gi, '') != '') szHTML = "<a href=\"javascript:\" onclick=\"var b=document.body,p=nextSibling;var st=b.scrollTop,oh=b.offsetHeight,t=40,h=140+t-st;if (h>oh){h=oh;}else if(h<0){h=t;} with(p.style){position='absolute';/*left=b.offsetWidth/2-150;*/top=h;display='block';}\"><img src=\"/Storage/" + m_company + "/pencil.gif\" border=\"0\" alt=\"" + strAlt(szComment) + "\" style=\"vertical-align:middle\" /></a>";
    szHTML += cmnt(szComment, node.selectSingleNode("partname").text, node.getAttribute("completed"), node.getAttribute("signstatus"));
    if (node.getAttribute("completed") != '') szHTML += node.getAttribute("completed").substr(3,5).replace('-','/');
    if (szHTML == '') szHTML = "&nbsp;";
    return szHTML;
  }
  function cmnt(s, n, d, ss) {
    if (s && s != '') {
      if (ss == "6") return "<div id=\"_cmnt_autopopup\" class=\"cmnt-popup cmnt-red\"><div class=\"cmnt-btn\"><span>("+XF.parse.signStatus(ss)+") "+n+" : "+d+"</span><button class=\"cmnt-btn\" onclick=\"parentNode.parentNode.style.display='none';return false\">X</button></div><div class=\"cmnt-lst\">" + encodeHtml(s) + "</div></div>";
      else return "<div class=\"cmnt-popup\"><div class=\"cmnt-btn\"><span>("+XF.parse.signStatus(ss)+") "+n+" : "+d+"</span><button class=\"cmnt-btn\" onclick=\"parentNode.parentNode.style.display='none';return false\">X</button></div><div class=\"cmnt-lst\">" + encodeHtml(s) + "</div></div>";
    } else return "";
  }
  function fieldValue(p, n, path, v) {
    var rt = v;
    if (p.length > 0 && v.length == 0) {
      if (n.length == 1) n = "0" + n;
      var node = p[0].selectSingleNode("foption[@cd='f" + n + "']");
      if (node) {
        var c = node.selectSingleNode(path);
        if (c && c.text != '') rt = c.text;
      }
    }
    return rt;
  }
  function fieldValue1(p, comp, opt) {
    var rt = "";
    if (p.length > 0) {
      var q = "foption1[@cd='" + comp + "'";
      if (opt == 'A' || opt == 'B') q += " and lnk='N'"
      else if (opt == 'C' || opt == 'D') q += " and lnk='Y'"
      if (arguments[3] && arguments[3] != '') q += " and ./k2='" + arguments[3] + "'";
      q += "]";
      var node = p[0].selectSingleNode(q);
      if (node) {
        if (opt == 'A' || opt == 'C') {rt = (node.selectSingleNode("pistart").text.indexOf('2999') >= 0) ? "" : node.selectSingleNode("pistart").text;} //2014-07-18 piend->pistart
        else if (opt == 'B' || opt == 'D') {rt = (node.selectSingleNode("state").text != "") ? "O" : "";}
        //if (rt != '' && arguments[4] && arguments[4] != '') {rt = "<a href=\"javascript:parent.openXForm('" + arguments[4] + "','" + node.selectSingleNode("mi").text + "','" + node.selectSingleNode("oi").text + "');\">" + rt + "</a>";}
		if (rt != '' && arguments[4] && arguments[4] != '') {rt = "<a href=\"javascript:_zw.fn.openXForm('" + arguments[4] + "','" + node.selectSingleNode("mi").text + "','" + node.selectSingleNode("oi").text + "');\">" + rt + "</a>";}
      }
    }
    return isEmpty(rt);
  }
  function fieldValue2(p, n, path, fld, v, len) {
    var szHTML = " class=\"txtText\" maxlength=\"" + len + "\" value=\"" + v + "\" />";
    if (p.length > 0 && v.length == 0) {
      if (n.length == 1) n = "0" + n;
      var node = p[0].selectSingleNode("foption[@cd='f" + n + "']");
      if (node) {      
        var c = node.selectSingleNode(path);
        if (c && c.text != '') szHTML = " class=\"txtText\" maxlength=\"" + len + "\" value=\"" + c.text + "\" />";
      }
    }
    return "<input type=\"text\" name=\"" + fld + "\"" + szHTML;
  }
  function gg(a) {
  
  return 1;
  }
  
  function fieldValue3(opt, s, v1, v2) {  
    var rt = "";
    if (opt == 'B') {if (v1 != '') rt = "<a href=\"javascript:_zw.fn.openXForm('read', '" + v1 + "','" + v2 + "');\">" + s + "</a>";}
    return isEmpty(rt);
  }
  function fieldValue4(p, comp, nm) {//2012-02-28
    var rt = "";
    if (p.length > 0) {
      var col = p[0].selectNodes("foption1[@cd='" + comp + "']");
      if (col.length > 0) {
        rt = "<div class=\"lkm-popup\" style=\"display:none\"><div class=\"lkm-btn\"><span>:: " + nm + "</span><button onclick=\"parentNode.parentNode.style.display='none';return false;\">X</button></div><div class=\"lkm-lst\">";
        for(var i=0; i<col.length; i++) {
          rt += "<div class=\"lkm-item\">" + fieldValue3('B', "[" + col[i].selectSingleNode("piend").text + "]" + col[i].selectSingleNode("piname").text, col[i].selectSingleNode("mi").text, col[i].selectSingleNode("oi").text) + "</div>";
        }
        rt += "</div></div>";
      }
    }
    if (rt == '') rt = isEmpty(nm);
    else {
      rt = "<a style=\"cursor:pointer;color:#05a;\" onclick=\"var b=document.body,p=nextSibling;var st=b.scrollTop,oh=b.offsetHeight,h=event.y-40+st; with(p.style){position='absolute';left=event.x+80;top=h;display='block';}\">" + nm + "</a>" + rt;
    }
    return rt;
  }
  function fieldValue5(s, p, d) {
    var c = null, q = null;
    if (d) {
      switch (d) {
        case "설계": c = s[0].selectNodes("row[./CHARGEDEPT='설계' or ./CHARGEDEPT='설계/기연' or ./CHARGEDEPT='설계/기연/영업' or ./CHARGEDEPT='설계/기연/기술']"); break;
        //case "기술연구소": c = s[0].selectNodes("row/CHARGEDEPT[.='기술연구소']"); break;
        case "기술연구소": c = s[0].selectNodes("row[./CHARGEDEPT='기술연구소']"); break;
        case "기술": c = s[0].selectNodes("row[./CHARGEDEPT='기술' or ./CHARGEDEPT='기술/품질' or ./CHARGEDEPT='설계/기연/기술']"); break;
        case "품질": c = s[0].selectNodes("row[./CHARGEDEPT='품질' or ./CHARGEDEPT='환경']"); break;
        case "영업": c = s[0].selectNodes("row[./CHARGEDEPT='영업']"); break;
        case "설계관리": c = s[0].selectNodes("row[./CHARGEDEPT='설계관리']"); break;
      }
    } else {
      c = s[0].selectNodes("row");
    }
    var iDesign = 0, iEp = 0, iPp = 0, iPmp = 0, iDesignChk = 0, iEpChk = 0, iPpChk = 0, iPmpChk = 0;
    for(var i=0; i<c.length; i++) {
      if (c[i].selectSingleNode("PRODUCTID") && c[i].selectSingleNode("PRODUCTID").text != '') q = p[0].selectNodes("foption1[@cd='" + c[i].selectSingleNode("PRODUCTID").text + "']");
      else q = null;
      if ((c[i].selectSingleNode("DESIGNCHECK") && c[i].selectSingleNode("DESIGNCHECK").text == 'Y')
        || (c[i].selectSingleNode("DESIGNLINKCHECK") && c[i].selectSingleNode("DESIGNLINKCHECK").text == 'Y')) {
          if (d && d == "기술" && c[i].selectSingleNode("CHARGEDEPT").text == "설계/기연/기술") {
            //이 경우는 카운트 않는다.
          } else {
            iDesign++;
            if (q) {for(var j=0; j<q.length; j++) {if (q[j].selectSingleNode("k2").text == "" || q[j].selectSingleNode("k2").text == "PLAN") {iDesignChk++;break;}}}
          }
      }
      if ((c[i].selectSingleNode("EPPLANCHECK") && c[i].selectSingleNode("EPPLANCHECK").text == 'Y')
        || (c[i].selectSingleNode("EPPLANLINKCHECK") && c[i].selectSingleNode("EPPLANLINKCHECK").text == 'Y')) {
          if (d && d == "기술" && c[i].selectSingleNode("CHARGEDEPT").text == "설계/기연/기술") {
            //이 경우는 카운트 않는다.
          } else {
            iEp++;
            if (q) {for(var j=0; j<q.length; j++) {if (q[j].selectSingleNode("k2").text == "EP") {iEpChk++;break;}}}
          }
      }
      if ((c[i].selectSingleNode("PPPLANCHECK") && c[i].selectSingleNode("PPPLANCHECK").text == 'Y')
        || (c[i].selectSingleNode("PPPLANLINKCHECK") && c[i].selectSingleNode("PPPLANLINKCHECK").text == 'Y')) {
          if (d && d == "설계" && c[i].selectSingleNode("CHARGEDEPT").text == "설계/기연/기술") {
            //이 경우는 카운트 않는다.
          } else {
            iPp++;
            if (q) {for(var j=0; j<q.length; j++) {if (q[j].selectSingleNode("k2").text == "PP") {iPpChk++;break;}}}
          }
      }
      if ((c[i].selectSingleNode("PMPPLANCHECK") && c[i].selectSingleNode("PMPPLANCHECK").text == 'Y')
        || (c[i].selectSingleNode("PMPPLANLINKCHECK") && c[i].selectSingleNode("PMPPLANLINKCHECK").text == 'Y')) {
          if (d && d == "설계" && c[i].selectSingleNode("CHARGEDEPT").text == "설계/기연/기술") {
            //이 경우는 카운트 않는다.
          } else {
            iPmp++;
            if (q) {for(var j=0; j<q.length; j++) {if (q[j].selectSingleNode("k2").text == "PMP") {iPmpChk++;break;}}}
          }
      }
    }
    //return iDesign + "/" + iDesignChk + " : " + iEp + "/" + iEpChk + " : " + iPp + "/" + iPpChk + " : " + iPmp + "/" + iPmpChk;
    var m = iDesignChk + iEpChk + iPpChk + iPmpChk, n = iDesign + iEp + iPp + iPmp;
    if (n == 0) return "&nbsp;";
    else {
      return (m * 100 / n).toFixed(1) + "% (" + m + "/" + n + ")";
    }
  }
  function optionValue(p, fld, v, dn, dnv, w) {
  //log("A->"+arguments[6])
    var iW = (w && w!='' && w!='0') ? w : "100%";
    var tab = (arguments[6] && arguments[6]!='' && arguments[6]!='0') ? "tabindex=\"" + arguments[6] + "\"" : "";
    var szId = (arguments[7] && arguments[7]!='') ? "id=\"" + arguments[7] + "\"" : "";
    //var szHTML = "<select " + szId + " name=\"" + fld + "\" onchange=\"parent.fnSelectChange(this);\" " + tab + " style=\"width:" + iW + "\"><option value=\"\">선택</option>";
	var szHTML = "<select " + szId + " name=\"" + fld + "\" onchange=\"_zw.formEx.change(this);\" " + tab + " style=\"width:" + iW + "\" class=\"form-control\"><option value=\"\">선택</option>";
    if (p.length > 0) {
      for(var i=0; i<p.length; i++) {
        szHTML += "<option value=\"" + p[i].selectSingleNode("Item2").text + "\""
        if (v == p[i].selectSingleNode("Item2").text) szHTML += " selected=\"selected\""
        szHTML += ">" + p[i].selectSingleNode("Item1").text + "</option>";
      }
    }    
    szHTML += "</select>";
    if (dn && dn != '') szHTML += "<input type=\"hidden\" " + szId + " name=\"" + dn + "\" value=\"" + dnv + "\" />";
    return szHTML;
  }
  //function linkPlate(pn) {return "<a href=\"javascript:\" onclick=\"parent.showEAPlate('A', 'approval', '');\">" + pn + "</a>";}
  function linkPlate(pn) {return "<a href=\"javascript:\" onclick=\"_zw.fn.showSignPlate('approval');\">" + pn + "</a>";}
  //function linkPersonInfo(w, r, pn, pid, pcn) {if (pid.indexOf('_') > 0) {return pn;} else {return "<a href=\"javascript:\" onclick=\"var url = 'https://" + w + "/" + r + "/PortalService/Person/PersonSimpleInfo.aspx?userid=" + pid + "&logonid=" + pcn + "'; var x = 430, y = 370; var sy = window.screen.height / 2 - y / 2 - 70; var sx = window.screen.width  / 2 - x / 2; if (sy < 0) {sy = 0;} var param = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,top=' + sy + ',left=' + sx + ',width=' + x + ',height=' + y; window.open(url,'사용자정보', param);\">" + pn + "</a>";}}
  function linkPersonInfo(w, r, pn, pid, pcn) {if (pid.indexOf('_') > 0) {return pn;} else {return "<a href=\"javascript:\" onclick=\"var url = '/" + r + "/PortalService/Person/PersonSimpleInfo.aspx?userid=" + pid + "&logonid=" + pcn + "'; var x = 430, y = 500; var sy = window.screen.height / 2 - y / 2 - 70; var sx = window.screen.width  / 2 - x / 2; if (sy < 0) {sy = 0;} var param = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,top=' + sy + ',left=' + sx + ',width=' + x + ',height=' + y; window.open(url,'사용자정보', param);\">" + pn + "</a>";}}
  function linkCEMain(w, r, pn, pid) {if (pid.indexOf('_') > 0) {return pn;} else {return "<a href=\"javascript:\" onclick=\"var url = 'https://" + w + "/" + r + "/ExtensionService/CE/Grid.aspx?M=simul&app=" + pid + "&Q=lnk'; var w = window.screen.width; var h = window.screen.height; w = w >= 1400 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h; var sy = window.screen.height / 2 - h / 2 - 70; var sx = window.screen.width  / 2 - w / 2; if (sy < 0) {sy = 0;} var param = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,top=' + sy + ',left=' + sx + ',width=' + w + ',height=' + h; window.open(url,'ce_grid', param);\">" + pn + "</a>";}}
  
  function getSignImage(node) {
	  if (node) {
		  if (node.selectSingleNode("sign").text == "") {
        if (node.getAttribute("actrole") == "_drafter") return XF.parse.lineBox('i') + "<br />";
        else if (node.getAttribute("actrole") == "_redrafter") return XF.parse.lineBox('h') + "<br />";
        else if (node.getAttribute("actrole") == "_reviewer") return XF.parse.lineBox('d') + "<br />";
        else return XF.parse.signStatus(parseInt(node.getAttribute("signstatus"))) + "<br />";
      } else {
        //return "<img style=\"width:70;height:50;border:0;\" alt=\"\" src=\"" + node.selectSingleNode("sign").text + "\" />";
        return "<img style=\"border:0;\" alt=\"" + node.selectSingleNode("partname").text + "\" src=\"" + node.selectSingleNode("sign").text + "\" onload=\"var w=this.offsetWidth,h=this.offsetHeight;if((w/h).toFixed(1)>=1.4){if(w>70){this.style.width='70px';}}else{if(h>50){this.style.height='50px';}}\" />";
      }
	  } else {
		  //return "<img style=\"width:44;height:45;border:0;\" alt=\"\" src=\"/" + m_root + "/EA/Images/crossline.gif\" />";
		  return "<img style=\"width:44;height:45;border:0;\" alt=\"\" src=\"/Storage/" + m_company + "/crossline.gif\" />";
	  }
  }	
  function mappingSignPart(c, nodes, id, cellCnt) {
	  var iCell = cellCnt;
	  var iNodes = nodes.length;
	  var iDiff = iCell-iNodes;
	  var k = 0;
    
    var szBorder = (arguments[5] && arguments[5] == "N") ? " style=\"border-right:0 solid windowtext\"" : "";
	  var szHTML = "<table id=\"" + id + "\" class=\"si-tbl\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"" + szBorder + ">";
	  var szTop = "", szMid = "", szBot = "";
	  var szTopRow = "", szMidRow = "", szBotRow = "";
	  var szStyle1 = "", szStyle2 = "", szStyle3 = "";
		
	  //log("iNodes:" + iNodes + "----" + "iCell:" + iCell + "----" + " partid:" + m_partid);

	  for (var i=iCell-1; i>=0; i--) {
		  if (iNodes > 0) {
			  if (i==0) {
          if (id == "__si_Normal" || id == "__si_Complex") szTop = XF.parse.lineBox('i');
          else if (id == "__si_Receive" || id == "__si_Form" || id == "__si_Form2") szTop = XF.parse.lineBox('b'); //2013-07-25
          else if (id == "__si_Distribution") szTop = XF.parse.lineBox('h');
          else if (id == "__si_Application_R") szTop = XF.parse.lineBox('h');
          else szTop = isEmpty(nodes[k].selectSingleNode("part5").text);
				  szMid = insertMiddleHTML(nodes[iNodes-1]);
				  szBot = insertBottomHTML(nodes[iNodes-1]);//convertDate(nodes[iNodes-1].getAttribute("completed"));
			  } else {
				  if ((i-iDiff) > 0) {
					  szTop = isEmpty(nodes[k].selectSingleNode("part5").text);//(k==0) ? XF.parse.lineBox('c') : (XF.parse.lineBox('d') + (iNodes-k-1));
						
					  //if (i==3) {log("szTop : " + szTop + " --- szMid : " + szMid);return "";}
						
					  szMid = insertMiddleHTML(nodes[k]);
					  szBot = insertBottomHTML(nodes[k]); //convertDate(nodes[k].getAttribute("completed"));
					  k++;
				  } else {
					  szTop = "&nbsp;";
					  szMid = getSignImage(null);
					  szBot = "&nbsp;";
					  szStyle3 = ";background-color:#f7f7f7";
				  }
			  }
		  } else {
			  szTop = "&nbsp;";
			  szMid = "&nbsp;";
			  szBot = "&nbsp;";
		  }
			
		  szStyle1 = (i==iCell-1) ? " style=\"border-right:0" + szStyle3 + "\">" : " style=\"" + szStyle3 + "\">";
		  szStyle2 = (i==iCell-1) ? " style=\"border-bottom:0;border-right:0" + szStyle3 + "\">" : " style=\"border-bottom:0" + szStyle3 + "\">";
		  szStyle3 = "";

		  szTop = "<td class=\"si-top\"" + szStyle1 + szTop + "</td>";
		  szMid = "<td class=\"si-middle\"" + szStyle1 + szMid + "</td>";
		  szBot = "<td class=\"si-bottom\"" + szStyle2 + szBot + "</td>";
		
		  szTopRow = szTop + szTopRow;
		  szMidRow = szMid + szMidRow;
		  szBotRow = szBot + szBotRow;
	  }
  //if (i==4) {log("i : " + i);return "";}	
	  var szTitle = "";
    if (arguments[4]) {
      szTitle = arguments[4];
    } else {
	    if (id == "__si_Receive") szTitle = XF.parse.lineBox('f');
	    else if (id == "__si_Consent" || id == "__si_Agree") szTitle = XF.parse.lineBox('g');
	    else if (id == "__si_Application") szTitle = XF.parse.lineBox('h');
      else if (id == "__si_Last") szTitle = XF.parse.lineBox('c');
	    else szTitle = XF.parse.lineBox('e');
    }
	  szTopRow = (szTitle == 'X') ? "<tr>" + szTopRow + "</tr>" : "<tr><td class=\"si-title\" rowspan=\"3\" style=\"border-bottom:0;\">" + szTitle + "</td>" + szTopRow + "</tr>";
	  szMidRow = "<tr>" + szMidRow + "</tr>";
	  szBotRow = "<tr>" + szBotRow + "</tr>";

	  return szHTML + szTopRow + szMidRow + szBotRow + "</table>";
  }
  function mappingSignRcvPart(c, nodes, role, id, cellCnt) {
	  var p = null, c = null;
    if (m_bizrole == role) {//해당 수신에서 결재중이면
      p = nodes[0].selectSingleNode("line[@bizrole='" + m_bizrole + "' and @partid='" + m_partid + "']");
      if (m_actrole.indexOf("__") >= 0) return mappingSignPart(m_root, 0, id, cellCnt, arguments[5]);
      else return mappingSignPart(m_root, nodes[0].selectNodes("line[@parent='" + p.getAttribute("parent") + "' and @partid!='' and @step!='0']"), id, cellCnt, arguments[5]);
    }
    if (nodes.length > 0) {
      p = nodes[0].selectNodes("line[@bizrole='" + role + "' and @parent='' and @step!='0']");
      if (p.length == 1) {//수신부서가 1개면
        c = nodes[0].selectNodes("line[@parent='" + p[0].getAttribute("wid") + "' and @actrole!='_re' and @partid!='' and @step!='0']");
        if (c.length > 0) return mappingSignPart(m_root, c, id, cellCnt, arguments[5]);
      }
      p = nodes[0].selectNodes("line[@bizrole='" + role + "' and @parent='' and @partid!='' and @step!='0']");
    }
    
    var szBorder = (arguments[6] && arguments[6] == "N") ? " style=\"border-right:0pt solid windowtext\"" : "";
	  var szHTML = "<table id=\"" + id + "\" class=\"si-tbl\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"" + szBorder + ">";
	  var szTop = "", szMid = "", szBot = "";
	  var szTopRow = "", szMidRow = "", szBotRow = "";
	  var szStyle1 = "", szStyle2 = "", szStyle3 = "";
    
    for (var i=0; i<cellCnt; i++) {
		  if (p && p.length > 0) {
        if (p[p.length-1-i]) {
			  	  szTop = "&nbsp;";
					  szMid = p[p.length-1-i].selectSingleNode("partname").text;
            if (p[p.length-1-i].getAttribute("state") == "7") {
              szMid += "<br />" + XF.parse.signStatus(p[p.length-1-i].getAttribute("signstatus"));
	          } else if (p[p.length-1-i].getAttribute("state") == "4") {
              szMid += "<br />" + XF.parse.workItemState(4);
	          }
					  szBot = insertBottomHTML(p[p.length-1-i]); //convertDate(p[p.length-1-i].getAttribute("completed"));
			  } else {
				  szTop = "&nbsp;";
				  szMid = getSignImage(null);
				  szBot = "&nbsp;";
				  szStyle3 = ";background-color:#f7f7f7";
			  }
		  } else {
			  szTop = "&nbsp;";
			  szMid = "&nbsp;";
			  szBot = "&nbsp;";
		  }
			
		  szStyle1 = (i==cellCnt-1) ? " style=\"border-right:0" + szStyle3 + "\">" : " style=\"" + szStyle3 + "\">";
		  szStyle2 = (i==cellCnt-1) ? " style=\"border-bottom:0;border-right:0" + szStyle3 + "\">" : " style=\"border-bottom:0" + szStyle3 + "\">";
		  szStyle3 = "";

		  szTop = "<td class=\"si-top\"" + szStyle1 + szTop + "</td>";
		  szMid = "<td class=\"si-middle\"" + szStyle1 + szMid + "</td>";
		  szBot = "<td class=\"si-bottom\"" + szStyle2 + szBot + "</td>";
		
		  szTopRow += szTop;
		  szMidRow += szMid;
		  szBotRow += szBot;
	  }

	  var szTitle = "";
    if (arguments[5]) {
      szTitle = arguments[5];
    } else {
	    if (id == "__si_Consent") szTitle = XF.parse.lineBox('g');
	    else if (id == "__si_Application") szTitle = XF.parse.lineBox('h');
	    else szTitle = XF.parse.lineBox('f');
    }
	  szTopRow = (szTitle == 'X') ? "<tr>" + szTopRow + "</tr>" : "<tr><td class=\"si-title\" rowspan=\"3\" style=\"border-bottom:0;\">" + szTitle + "</td>" + szTopRow + "</tr>";
	  szMidRow = "<tr>" + szMidRow + "</tr>";
	  szBotRow = "<tr>" + szBotRow + "</tr>";

	  return szHTML + szTopRow + szMidRow + szBotRow + "</table>";
  }
  function mappingSignSerialPart(c, nodes, id, cellCnt) {
    var szBorder = (arguments[5] && arguments[5] == "N") ? " style=\"border-right:0pt solid windowtext\"" : "";
    var szAttr = (arguments[7] && arguments[7] != "") ? " " + arguments[7] : "";
	  var szHTML = "<table id=\"" + id + "\" class=\"si-tbl\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"" + szBorder + szAttr + ">";
	  var szTop = "", szMid = "", szBot = "";
	  var szTopRow = "", szMidRow = "", szBotRow = "";
	  var szStyle1 = "", szStyle2 = "", szStyle3 = "";
		
	  for (var i=0; i<cellCnt; i++) {
		  if (nodes.length > 0) {
        if (nodes[nodes.length-i-1]) {
            if (arguments[6] && arguments[6] == "BR") szTop = XF.parse.bizRole(nodes[nodes.length-i-1].getAttribute("bizrole"));
            else if (arguments[6] && arguments[6] == "AR") szTop = XF.parse.actRole(nodes[nodes.length-i-1].getAttribute("actrole"));
			  	  else {
              if (id == "__si_Form") {
                if (nodes[nodes.length-i-1].getAttribute("actrole") == "_redrafter") szTop = XF.parse.lineBox('b');
                else szTop = isEmpty(nodes[nodes.length-i-1].selectSingleNode("part5").text);
              } else {
                szTop = isEmpty(nodes[nodes.length-i-1].selectSingleNode("part5").text);
              }
            }
					  szMid = insertMiddleHTML(nodes[nodes.length-i-1]);
					  szBot = insertBottomHTML(nodes[nodes.length-i-1]); //convertDate(nodes[nodes.length-i-1].getAttribute("completed"));
			  } else {
				  szTop = "&nbsp;";
				  szMid = getSignImage(null);
				  szBot = "&nbsp;";
				  szStyle3 = ";background-color:#f7f7f7";
			  }
		  } else {
			  szTop = "&nbsp;";
			  szMid = "&nbsp;";
			  szBot = "&nbsp;";
		  }
			
		  szStyle1 = (i==cellCnt-1) ? " style=\"border-right:0" + szStyle3 + "\">" : " style=\"" + szStyle3 + "\">";
		  szStyle2 = (i==cellCnt-1) ? " style=\"border-bottom:0;border-right:0" + szStyle3 + "\">" : " style=\"border-bottom:0" + szStyle3 + "\">";
		  szStyle3 = "";

		  szTop = "<td class=\"si-top\"" + szStyle1 + szTop + "</td>";
		  szMid = "<td class=\"si-middle\"" + szStyle1 + szMid + "</td>";
		  szBot = "<td class=\"si-bottom\"" + szStyle2 + szBot + "</td>";
		
		  szTopRow += szTop;
		  szMidRow += szMid;
		  szBotRow += szBot;
	  }

	  var szTitle = "";
    if (arguments[4]) {
      szTitle = arguments[4];
    } else {
	    if (id == "__si_Receive") szTitle = XF.parse.lineBox('f');
	    else if (id == "__si_Consent" || id == "__si_Agree") szTitle = XF.parse.lineBox('g');
	    else if (id == "__si_Application") szTitle = XF.parse.lineBox('h');
      else if (id == "__si_Last") szTitle = XF.parse.lineBox('c');
	    else szTitle = XF.parse.lineBox('e');
    }
	  szTopRow = (szTitle == 'X') ? "<tr>" + szTopRow + "</tr>" : "<tr><td class=\"si-title\" rowspan=\"3\" style=\"border-bottom:0;\">" + szTitle + "</td>" + szTopRow + "</tr>";
	  szMidRow = "<tr>" + szMidRow + "</tr>";
	  szBotRow = "<tr>" + szBotRow + "</tr>";

	  return szHTML + szTopRow + szMidRow + szBotRow + "</table>";
  }
  function mappingSignEdgePart(c, nodes, id, cellCnt) {
	  var iNodes = nodes.length;
	  var iDiff = cellCnt-iNodes;
    var k = 0;
	var szBorder = (arguments[5] && arguments[5] == "N") ? ";border-right:0pt" : ""; //2022-09-15 추가
	
    var szHTML = "<table id=\"" + id + "\" class=\"si-tbl\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-left:0" + szBorder + "\">";
	  var szTop = "", szMid = "", szBot = "";
	  var szTopRow = "", szMidRow = "", szBotRow = "";
	  var szStyle1 = "", szStyle2 = "", szStyle3 = "";
		
	  for (var i=cellCnt-1; i>=0; i--) {
		  if (iNodes > 0) {
        if ((i-iDiff) >= 0) {
          if (arguments[4] && arguments[4] == "BR") szTop = XF.parse.bizRole(nodes[k].getAttribute("bizrole"));
          else if (arguments[4] && arguments[4] == "AR") szTop = XF.parse.actRole(nodes[k].getAttribute("actrole"));
		  	  else szTop = isEmpty(nodes[k].selectSingleNode("part5").text);
				  szMid = insertMiddleHTML(nodes[k]);
				  szBot = insertBottomHTML(nodes[k]); //convertDate(nodes[k].getAttribute("completed"));
          k++;
			  } else {
				  szTop = "&nbsp;";
				  szMid = getSignImage(null);
				  szBot = "&nbsp;";
				  szStyle3 = ";background-color:#f7f7f7";
			  }
		  } else {
			  szTop = "&nbsp;";
			  szMid = "&nbsp;";
			  szBot = "&nbsp;";
		  }
			
		  szStyle1 = (i==cellCnt-1) ? " style=\"border-right:0" + szStyle3 + "\">" : " style=\"" + szStyle3 + "\">";
		  szStyle2 = (i==cellCnt-1) ? " style=\"border-bottom:0;border-right:0" + szStyle3 + "\">" : " style=\"border-bottom:0" + szStyle3 + "\">";
		  szStyle3 = "";

		  szTop = "<td class=\"si-top\"" + szStyle1 + szTop + "</td>";
		  szMid = "<td class=\"si-middle\"" + szStyle1 + szMid + "</td>";
		  szBot = "<td class=\"si-bottom\"" + szStyle2 + szBot + "</td>";
		
		  szTopRow = szTop + szTopRow;
		  szMidRow = szMid + szMidRow;
		  szBotRow = szBot + szBotRow;
	  }

	  szTopRow = "<tr>" + szTopRow + "</tr>";
	  szMidRow = "<tr>" + szMidRow + "</tr>";
	  szBotRow = "<tr>" + szBotRow + "</tr>";

	  return szHTML + szTopRow + szMidRow + szBotRow + "</table>";
  }
  function mappingSignSinglePart(c, nodes, biz, act, hd) {  
    var szHTML = "<table id=\"__si_OnlyOne\" biz=\"" + biz + "\" act=\"" + act + "\" class=\"si-tbl\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
    var szTop = "", szMid = "", szBot = "";
    if (nodes.length > 0) {
      var p = nodes[0].selectNodes("line[@bizrole='" + biz + "' and @actrole='" + act + "' and @partid!='']");
      if (p.length > 0) {
        szTop = (hd == '') ? XF.parse.actRole(p[0].getAttribute("actrole")) : hd;
        szMid = insertMiddleHTML(p[0]);
			  szBot = insertBottomHTML(p[0]); //convertDate(p[0].getAttribute("completed"));
      } else {
        szTop = isEmpty(hd); szMid = "&nbsp;"; szBot = "&nbsp;";
      }
    } else {
      szTop = isEmpty(hd); szMid = "&nbsp;"; szBot = "&nbsp;";
    }
    szTop = "<tr><td class=\"si-top\">" + szTop + "</td></tr>";
    szMid = "<tr><td class=\"si-middle\">" + szMid + "</td></tr>";
    szBot = "<tr><td class=\"si-bottom\">" + szBot + "</td></tr>";
    
    return szHTML + szTop + szMid + szBot + "</table>";
  }
  function mappingSignTable(nodes) {
    var p = nodes[0].selectNodes("line[@parent='' and @partid!='' and @step!='0' and @bizrole!='reference']");
    var c = null;
    var szStyle = "", szComment = "";
    
    var szHTML = "<table class=\"si-list\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
    szHTML += "<thead><tr class=\"si-hdr\">";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:5%;\">" + XF.parse.header("sq") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:10%;\">" + XF.parse.header("ct") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:22%;\">" + XF.parse.header("at") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:9%;\">" + XF.parse.header("ws") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:9%;\">" + XF.parse.header("ss") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:7%;\">" + XF.parse.header("sk") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:14%;\">" + XF.parse.header("do") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:14%;\">" + XF.parse.header("rv") + "</td>";
    szHTML += "<td nowrap=\"nowrap\" style=\"width:10%;border-right:0\">" + XF.parse.header("iv") + "</td>";
    szHTML += "</tr></thead><tbody>";

    for(var i=0; i<p.length; i++) {
      szStyle = (i<p.length-1) ? "" : " style=\"border-bottom:0\"";
      if (p[i].getAttribute("state")=="2" && p[i].getAttribute("viewstate")=="3") szHTML += "<tr class=\"si-cur\">"
      else szHTML += "<tr>";
      szHTML += "<td" + szStyle + ">" + p[i].getAttribute("step") + (p[i].getAttribute("substep")=="0" ? "" : "." + p[i].getAttribute("substep")) + "</td>";
      if (isGroup(p[i].getAttribute("parttype"))) {
        szHTML += "<td" + szStyle + ">" + XF.parse.bizRole(p[i].getAttribute("bizrole")) + "</td>";
        szHTML += "<td class=\"si-pname\" " + szStyle + ">" + isEmpty(p[i].selectSingleNode("partname").text) + "</td>";
      } else {
        if (p[i].getAttribute("bizrole") == "normal" || p[i].getAttribute("bizrole") == "receive") szHTML += "<td" + szStyle + ">" + XF.parse.actRole(p[i].getAttribute("actrole")) + "</td>";
        else if (p[i].getAttribute("bizrole") == "gwichaek") szHTML += "<td" + szStyle + ">" + XF.parse.actRole(p[i].getAttribute("actrole")) + "</td>";
        else if (p[i].getAttribute("bizrole") == "application" && p[i].getAttribute("actrole") == "_reviewer") szHTML += "<td" + szStyle + ">" + XF.parse.actRole(p[i].getAttribute("actrole")) + "</td>";
        else szHTML += "<td" + szStyle + ">" + XF.parse.bizRole(p[i].getAttribute("bizrole")) + "</td>";
        szHTML += "<td class=\"si-pname\" " + szStyle + ">" + isEmpty(p[i].selectSingleNode("part1").text) + "." + isEmpty(p[i].selectSingleNode("partname").text) + "</td>";
      }
      szHTML += "<td" + szStyle + ">" + XF.parse.workItemState(p[i].getAttribute("state")) + "</td>";
      szHTML += "<td" + szStyle + ">" + XF.parse.signStatus(p[i].getAttribute("signstatus")) + "</td>";
      szHTML += "<td" + szStyle + ">" + XF.parse.signKind(p[i].getAttribute("signkind")) + "</td>";
      
      szHTML += "<td" + szStyle + ">" + isEmpty(p[i].getAttribute("completed")) + "</td>";
      szHTML += "<td" + szStyle + ">" + isEmpty(p[i].getAttribute("received")) + "</td>";
      if (i<p.length-1) szHTML += "<td style=\"border-right:0\">" + isEmpty(p[i].getAttribute("interval")) + "</td></tr>";
      else szHTML += "<td style=\"border-bottom:0;border-right:0\">" + isEmpty(p[i].getAttribute("interval")) + "</td></tr>";
      
      szComment = (p[i].getAttribute("state") == '2' || p[i].getAttribute("state") == '3') ? "" : p[i].selectSingleNode("comment").text; //2014-04-10 선결 첨언 다시 보기게
      //szComment = (parseInt(p[i].getAttribute("state")) < 4 && p[i].getAttribute("signstatus") != '3') ? "" : p[i].selectSingleNode("comment").text; //2014-03-20 처리 한 상태에서만 첨언 표시로 변경
      if (szComment.replace(/ /gi, '') != '') {
        if (i<p.length-1) szHTML += "<tr><td colspan=\"2\" style=\"border-right:0\">&nbsp;</td><td class=\"si-cmnt\" colspan=\"7\" style=\"border-right:0;font-size:13\">" + encodeHtml(szComment) + "</td></tr>";
        else szHTML += "<tr><td colspan=\"2\" style=\"border-top:1px solid windowtext;border-bottom:0;border-right:0\">&nbsp;</td><td class=\"si-cmnt\" colspan=\"7\" style=\"border-top:1px solid windowtext;border-bottom:0;border-right:0;font-size:13\">" + encodeHtml(szComment) + "</td></tr>";
      }
      c = nodes[0].selectNodes("line[@parent='" + p[i].getAttribute("wid") + "' and @partid!='' and @step!='0' and @bizrole!='reference']");
      if (c != null && c.length > 0) szHTML += sub(c);
      c = null;
    }
    szHTML += "</tbody></table>";
    
    //참조목록
    p = nodes[0].selectNodes("line[@partid!='' and @step!='0' and @bizrole='reference']");
    if (p != null && p.length > 0) {
      szHTML += "<table class=\"si-list\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"margin-top:10px\"><tr>";
      szHTML += "<td style=\"width:100px;border-right:1px solid windowtext;border-bottom:0;background-color:#eeeeee\">참조&nbsp;목록</td><td style=\"padding-left:11px;border-bottom:0;text-align:left\">";
      for (var i=0; i<p.length; i++) {
        if (isGroup(p[i].getAttribute("parttype"))) szHTML += "<span style=\"margin:2px\">" + p[i].selectSingleNode("partname").text;
        else szHTML += "<span style=\"margin:2px\">" + p[i].selectSingleNode("part1").text + "." + p[i].selectSingleNode("partname").text;
        if (i<p.length-1) szHTML += ", ";
        szHTML += "</span>";
      }
      szHTML += "</td></tr></table>";
    }
    return szHTML;
  }
  function sub(p) {
    var szHTML = "", szStyle = "", szComment = "";
    if (p.length > 0) {
      szHTML += "<tr><td colspan=\"9\" class=\"si-subtd\"><table class=\"si-sublist\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
      szHTML += "<colgroup><col style=\"width:4%\" /><col style=\"width:10%\" /><col style=\"width:22%\" /><col style=\"width:9%\" /><col style=\"width:9%\" /><col style=\"width:7%\" /><col style=\"width:14%\" /><col style=\"width:14%\" /><col style=\"width:10%\" /></colgroup>"
      for(var i=0; i<p.length; i++) {
        szStyle = (i<p.length-1) ? "" : " style=\"border-bottom:0\"";
        if (p[i].getAttribute("state")=="2" && p[i].getAttribute("viewstate")=="3") szHTML += "<tr class=\"si-cur\">"
        else szHTML += "<tr>";
        szHTML += "<td" + szStyle + ">" + p[i].getAttribute("step") + (p[i].getAttribute("substep")=="0" ? "" : "." + p[i].getAttribute("substep")) + "</td>";
        
        //if (p[i].getAttribute("bizrole") == "application" || p[i].getAttribute("bizrole") == "distribution" || p[i].getAttribute("bizrole") == "receive") szHTML += "<td" + szStyle + ">" + XF.parse.actRole(p[i].getAttribute("actrole")) + "</td>";
        //else szHTML += "<td" + szStyle + ">" + XF.parse.bizRole(p[i].getAttribute("bizrole")) + "</td>";
        szHTML += "<td" + szStyle + ">" + XF.parse.actRole(p[i].getAttribute("actrole")) + "</td>";
        szHTML += "<td class=\"si-pname\" " + szStyle + ">" + isEmpty(p[i].selectSingleNode("part1").text) + "." + isEmpty(p[i].selectSingleNode("partname").text) + "</td>";
        
        szHTML += "<td" + szStyle + ">" + XF.parse.workItemState(p[i].getAttribute("state")) + "</td>";
        szHTML += "<td" + szStyle + ">" + XF.parse.signStatus(p[i].getAttribute("signstatus")) + "</td>";
        szHTML += "<td" + szStyle + ">" + XF.parse.signKind(p[i].getAttribute("signkind")) + "</td>";
        
        szHTML += "<td" + szStyle + ">" + isEmpty(p[i].getAttribute("completed")) + "</td>";
        szHTML += "<td" + szStyle + ">" + isEmpty(p[i].getAttribute("received")) + "</td>";
        if (i<p.length-1) szHTML += "<td style=\"border-right:0\">" + isEmpty(p[i].getAttribute("interval")) + "</td></tr>";
        else szHTML += "<td style=\"border-bottom:0;border-right:0\">" + isEmpty(p[i].getAttribute("interval")) + "</td></tr>";
        
        szComment = (p[i].getAttribute("state") == '2' || p[i].getAttribute("state") == '3') ? "" : p[i].selectSingleNode("comment").text; //2014-04-10 선결 첨언 다시 보기게
        //szComment = (parseInt(p[i].getAttribute("state")) < 4 && p[i].getAttribute("signstatus") != '3') ? "" : p[i].selectSingleNode("comment").text; //2014-03-20 처리 한 상태에서만 첨언 표시로 변경
        if (szComment.replace(/ /gi, '') != '') {
          if (i<p.length-1) szHTML += "<tr><td colspan=\"2\" style=\"border-right:0\">&nbsp;</td><td class=\"si-cmnt\" colspan=\"7\" style=\"border-right:0;font-size:13\">" + encodeHtml(szComment) + "</td></tr>";
          else szHTML += "<tr><td colspan=\"2\" style=\"border-top:1px dotted windowtext;border-bottom:0;border-right:0\">&nbsp;</td><td class=\"si-cmnt\" colspan=\"7\" style=\"border-top:1px dotted windowtext;border-bottom:0;border-right:0;font-size:13\">" + encodeHtml(szComment) + "</td></tr>";
        }
      }
      szHTML += "</table></td></tr>";
    }
    return szHTML;
  }
  function cvtChartData(type, nodes) {//log("cnt->" + nodes[0].selectSingleNode("foption1[@cd='1']/rate1").text); return '';
    var rt = '', n = null;
    if (type == 'mg_r1') {
      for (var i=1; i<=12; i++) {
        if (i > 1) {rt += '^';}
        if (nodes.length > 0) {n = nodes[0].selectSingleNode("foption1[@cd='" + i.toString() + "']");} else {n = null;}
        if (n) {rt += n.selectSingleNode("rate1").text + ';' + n.getAttribute("cd"); if (i<=12) rt += "월 점유율:" + n.selectSingleNode("rate1").text + "%";}
        else rt += ';';
      }
    } else if (type == 'mg_r2') {
      for (var i=1; i<=12; i++) {
        if (i > 1) {rt += '^';}
        if (nodes.length > 0) {n = nodes[0].selectSingleNode("foption1[@cd='" + i.toString() + "']");} else {n = null;}
        if (n) {rt += n.selectSingleNode("rate2").text + ';' + n.getAttribute("cd"); if (i<=12) rt += "월 점유율:" + n.selectSingleNode("rate2").text + "%";}
        else rt += ';';
      }
    } else if (type == 'mg_r3') {
      for (var i=1; i<=12; i++) {
        if (i > 1) {rt += '^';}
        if (nodes.length > 0) {n = nodes[0].selectSingleNode("foption1[@cd='" + i.toString() + "']");} else {n = null;}
        if (n) {rt += n.selectSingleNode("rate3").text + ';' + n.getAttribute("cd"); if (i<=12) rt += "월 점유율:" + n.selectSingleNode("rate3").text + "%";}
        else rt += ';';
      }
    }
    return rt;
  }
  function renderLineChart(nodes, w, h, uY) {
    if (nodes.length == 0 || uY == "" || uY == "0") return "";
    //var vData = "3.5;2.1;1.4;3.7;4.1;0.7;1.6;2.1;5.9;1.8;2.3;3.4".split(';');
    for (var i=0; i<nodes.length; i++) {if (parseFloat(nodes[i].getAttribute("key")) > uY) {uY = parseFloat(nodes[i].getAttribute("key"));}}
    var iT=0, iL=0;
    var iW = w / nodes.length;
    var szFrom = "", szTo = "";
    var szVML = "";
    var szStokeColor = (arguments[4] && arguments[4].length > 0) ? arguments[4] : "";
    for (var i=0; i<nodes.length; i++) {
      if (nodes[i].getAttribute("key") != '') {
        iT = calcTop(h, uY, nodes[i].getAttribute("key"));
        iL = iW/2 + i*iW;
        szTo = iL + "px," + iT + "px";//log(iT + "==" + iL);
        szVML += setTick(iT, iL, "", "", "", szStokeColor, "", nodes[i].text);
        if (i > 0 && szFrom != "" && szTo != "") szVML += setLine(szFrom, szTo, "", szStokeColor, "", "", "", "");
        szFrom = szTo;
      }
    }
    if (szVML != '') szVML += "<v:line></v:line>";//마지막 요소 표시가 안돼 강제로 넣음
    return szVML;
  }  
  function renderLineSpecialChart(data, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt) {
    if (data.length == 0 || uY == "" || uY == "0") return "";
    var vData = data.split('^'), v = null;
    var iT=0, iL=0;
    var iW = w / vData.length;
    var szFrom = "", szTo = "", szVML = "";
    for (var i=0; i<vData.length; i++) {
      v = vData[i].split(';');
      if (v[0] != '') {
        iT = calcTop(h, uY, v[0]);
        iL = iW/2 + i*iW;
        szTo = iL + "px," + iT + "px";
        szVML += setTick(iT, iL, tw, th, tc, tsc, tdt, v[1], tls, tsw);
        if (i > 0 && szFrom != "" && szTo != "") szVML += setLine(szFrom, szTo, lw, lc, "", "", ldt, "");
        szFrom = szTo;
      }
    }
    if (szVML != '') szVML += "<v:line></v:line>";//마지막 요소 표시가 안돼 강제로 넣음
    return szVML;
  }
  function calcTop(y, uY, vlu) {
    return (parseFloat(y) - parseFloat(y) * parseFloat(vlu) / parseFloat(uY)).toFixed(0);
  }
  function setTick(t,l,w,h,c,sc,dt,tt) {
    if (w == "") w = 8; if (h == "") h = 8;
    if (c == "") c = "#ffffff";
    if (sc == "") sc = "#ff0000";//"#000000";
    if (dt == "") dt = "solid";
    var sText = (arguments[10] != null && arguments[10] != '') ? "<v:textbox>" + arguments[10] + "</v:textbox>" : "";
    var ls = (arguments[8] != null && arguments[8] != "") ? arguments[8] : "single";  //Single, ThinThin, ThinThick, ThickThin, ThickBetweenThin
    var sw = (arguments[9] != null && arguments[9] != "") ? arguments[9] : "1px";
    t -= h/2; l -= w/2;
    return "<v:oval style=\"z-index:10;position:absolute;top:" + t + "px;left:" + l + "px;width:" + w + "px;height:" + h + "px;cursor:pointer\" fillcolor=\"" + c + "\" strokecolor=\"" + sc + "\" title=\"" + tt + "\"><v:stroke dashstyle=\"" + dt + "\" linestyle=\"" + ls + "\" weight=\"" + sw + "\" />" + sText + "</v:oval>";
  }
  function setLine(f,t,sw,sc,sa,ea,dt,tt) {
    if (sw == "") sw = "1px";
    if (sc == "") sc = "red";//"#000000";
    if (sa == "") sa = "";  //block,classic,diamond,oval,open
    if (ea == "") ea = "";
    if (dt == "") dt = "shortdash"; //Solid, ShortDash, ShortDot,ShortDashDot,ShortDashDotDot,Dot,Dash,LongDash,DashDot,LongDashDot,LongDashDotDot
    var ls = (arguments[8] != null && arguments[8] != "") ? arguments[8] : "single";
    return "<v:line from=\"" + f + "\" to=\"" + t + "\" strokeweight=\"" + sw + "\" strokecolor=\"" + sc + "\" style=\"position:absolute\" title=\"" + tt + "\"><v:stroke startarrow=\"" + sa + "\" endarrow=\"" + ea + "\" dashstyle=\"" + dt + "\" linestyle=\"" + ls + "\" /></v:line>"
  }
  function baseStyle() {
    //return "html, body {margin:0px;padding:0px;width:100%}body {margin-bottom:2px;border:0;background-color:#ffffff;text-align:center;overflow:auto}.m,.m .ff,.m .fh,.m .fb,.m .fm,.m .fm1,.m .fm2,.m .fm3,.m .fm4,.m .fm-editor,.m .fm-lines {vertical-align:top}.m .ff {height:2px;font-size:1px}.m .fh {height:60px}.m .fb {height:80px}.m .fm-file,.m .fm-lines {text-align:left;}/* 폰트 */.fh h1 {font-family:굴림체;font-weight:bold}.si-tbl td {font-size:13px;font-family:궁서}.m .fm-lines .si-list td {font-size:12px;font-family:궁서}.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:13px;font-family:궁서}.m .ft-sub .ft-sub-sub td,.m .ft-sub .ft-sub-sub input,.m .ft-sub .ft-sub-sub select,.m .ft-sub .ft-sub-sub textarea,.m .ft-sub .ft-sub-sub div {font-size:13px;font-family:궁서}.m .fm span {font-size:14px;font-family:궁서}.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:13px;font-family:궁서}/* 로고 및 양식명 */.fh table {width:100%;height:100%}.fh .fh-l {width:150px;text-align:center}.fh .fh-m {padding-top:15px;text-align:center}.fh .fh-r {width:150px}.fh .fh-l img {border:0px solid red;vertical-align:middle;margin-top:0px}/* 결재칸 */.si-tbl {border:windowtext 1pt solid}.si-tbl td {vertical-align:middle;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid}.si-tbl .si-title {text-align:center;background-color:#eeeeee}.si-tbl .si-top {height:20px;text-align:center;padding-top:1px}.si-tbl .si-middle {height:65px;text-align:center}.si-tbl .si-bottom {height:20px;text-align:center}.si-tbl img {margin:0px}.m .fm-lines {padding-top:10px}.m .fm-lines table {width:100%;height:100%}.m .fm-lines .si-list {border:windowtext 1pt solid}.m .fm-lines .si-list td {text-align:center;height:24px;word-break:break-all;border-right:windowtext 0pt solid;border-bottom:windowtext 1pt solid}.m .fm-lines .si-subtd {border:0;padding-left:8px}.m .fm-lines .si-subtd .si-sublist {border:0;border-left:1px dotted windowtext}.m .fm-lines .si-subtd .si-sublist td {text-align:center;height:20px;word-break:break-all;border-right:windowtext 0pt dotted;border-bottom:windowtext 1pt dotted}.m .fm-lines .si-hdr td {background-color:#eeeeee}.m .fm-lines .si-cur td {background-color:#f7f3c1}.m .fm-lines .si-list .si-pname, .m .fm-lines .si-subtd .si-sublist .si-pname {text-align:left;padding-left:2px;padding-right:1px}.m .fm-lines .si-list .si-cmnt, .m .fm-lines .si-subtd .si-sublist .si-cmnt {text-align:left;padding:2px}/* 버튼 스타일 */.btn_bg {height:21px;border:1 solid #b1b1b1;background:url('/BizForce/EA/Images/btn_bg.gif');background-color:#ffffff;font-size:11px;letter-spacing:-1px;margin:0 2 0 2;padding:0 0 0 0 ;	vertical-align:middle;cursor:pointer}img.blt01 {margin:0 2 0 -2 ; vertical-align:middle;}.si-tbl img {margin:0px}/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */.m .ft {border:windowtext 1pt solid}.m .ft td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4 {text-align:center;background-color:#eeeeee}.m .ft input {height:20px}.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}.fm span {width:100%;text-align:left}.fm .fm-button {text-align:right}/* 본문 하위 테이블 */.m .ft-sub {border:windowtext 1pt solid;table-layout:}.m .ft-sub td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea {height:90%}.m .ft-sub input {height:20px}.m .ft-sub .ft-sub-sub {width:100%;border:0}.m .ft-sub .ft-sub-sub td {height:24px;word-break:break-all;border:0;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .ft-sub-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea,.m .ft-sub .ft-sub-sub textarea {height:90%}.m .ft-sub input,.m .ft-sub .ft-sub-sub input {height:20px}/* 첨부파일 */.m .fm-file table {height:100%}.m .fm-file td.file-title {vertical-align:top}.m .fm-file td.file-end {vertical-align:bottom;padding:0 0 3px 10px}.m .fm-file td.file-info {vertical-align:top}.m .fm-file td.file-info div {height:20px}/* 각종 필드 정의 - txt : input, txa : textarea */.m .txtText {ime-mode:active;width:100%;padding-top:1px}.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;padding-top:1px}.m .txtText_u {ime-mode:active;width:100%;border:0;border-bottom:1px solid #aaaaaa}.m .txaText {ime-mode:active;width:100%;overflow:auto}.m .txtNo {width:100%;padding-top:1px;padding-right:2;text-align:right}.m .txtNumberic, .m .txtVolume {width:100%;padding-top:1px;direction:rtl;padding-right:2;ime-mode:disabled}.m .txtJuminDash {width:100%;padding-top:1px;padding-right:2;text-align:center;ime-mode:disabled}.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3{direction:rtl;ime-mode:active;width:100%;padding-top:1px;padding-right:2;text-align:right;}.m .txtDate,.m .txtDateDot,.m .txtDateSlash,m .txtDateKo,.m .txtYear,.m .txtMonth,.m .txtHHmm,.m .txtHHmmss{ime-mode:disabled;width:100%;padding-top:1px;text-align:center;}.m .txtCalculate {ime-mode:active;width:100%;padding-top:1px;padding-right:2}.m .txaRead {width:100%;text-align:left}.m .txtRead {width:100%;border:0;padding-top:1px}.m .txtRead_Right {width:100%;border:0;padding-top:1px;padding-right:2;text-align:right}.m .txtRead_Center {width:100%;border:0;padding-top:1px;text-align:center}.m .ddlSelect {width:100%}.m .tdRead_Center {text-align:center}.m .tdRead_Right {text-align:right}/* 인쇄 설정 : 맨하단으로 */@media print {.m .fb td a, .m .fm-file td a {text-decoration:none;color:#000000}.m .fm-lines {padding-top:0}.m .fm-lines .si-hdr td,.m .fm-lines .si-cur td,.si-tbl .si-title,.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4,.m .ft-sub .f-lbl-sub,.m .ft-sub .ft-sub-sub .f-lbl-sub {background-color:#ffffff}}"
    return ""; //"html, body {margin:0px;padding:0px;width:100%}body {margin-bottom:2px;border:0;background-color:#ffffff;text-align:center;overflow:auto}.m,.m .ff,.m .fh,.m .fb,.m .fm,.m .fm1,.m .fm2,.m .fm3,.m .fm4,.m .fm-editor,.m .fm-lines {vertical-align:top}.m .ff {height:2px;font-size:1px}.m .fh {height:60px}.m .fb {height:80px}.m .fm-file,.m .fm-lines {text-align:left;}/* 폰트 */.fh h1 {font-family:굴림체;font-weight:bold}.si-tbl td {font-size:13px;font-family:맑은 고딕}.m .fm-lines .si-list td {font-size:12px;font-family:맑은 고딕}.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div, .m .ft select,.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div, .m .ft-sub select {font-size:13px;font-family:맑은 고딕}.m .ft-sub .ft-sub-sub td,.m .ft-sub .ft-sub-sub input,.m .ft-sub .ft-sub-sub select,.m .ft-sub .ft-sub-sub textarea,.m .ft-sub .ft-sub-sub div {font-size:13px;font-family:맑은 고딕}.m .fm span {font-size:14px;font-family:맑은 고딕}.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:13px;font-family:맑은 고딕}/* 로고 및 양식명 */.fh table {width:100%;height:100%}.fh .fh-l {width:150px;text-align:center}.fh .fh-m {padding-top:15px;text-align:center}.fh .fh-r {width:150px}.fh .fh-l img {border:0px solid red;vertical-align:middle;margin-top:0px}/* 결재칸 */.si-tbl {border:windowtext 1pt solid}.si-tbl td {vertical-align:middle;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid}.si-tbl .si-title {text-align:center;background-color:#eeeeee}.si-tbl .si-top {height:20px;text-align:center;padding-top:1px}.si-tbl .si-middle {height:65px;text-align:center}.si-tbl .si-bottom {height:20px;text-align:center}.si-tbl img {margin:0px}.m .fm-lines {padding-top:10px}.m .fm-lines table {width:100%;height:100%}.m .fm-lines .si-list {border:windowtext 1pt solid}.m .fm-lines .si-list td {text-align:center;height:24px;word-break:break-all;border-right:windowtext 0pt solid;border-bottom:windowtext 1pt solid}.m .fm-lines .si-subtd {border:0;padding-left:8px}.m .fm-lines .si-subtd .si-sublist {border:0;border-left:1px dotted windowtext}.m .fm-lines .si-subtd .si-sublist td {text-align:center;height:20px;word-break:break-all;border-right:windowtext 0pt dotted;border-bottom:windowtext 1pt dotted}.m .fm-lines .si-hdr td {background-color:#eeeeee}.m .fm-lines .si-cur td {background-color:#f7f3c1}.m .fm-lines .si-list .si-pname, .m .fm-lines .si-subtd .si-sublist .si-pname {text-align:left;padding-left:2px;padding-right:1px}.m .fm-lines .si-list .si-cmnt, .m .fm-lines .si-subtd .si-sublist .si-cmnt {text-align:left;padding:2px}/* 결재칸 첨언표시 */.cmnt-popup {left:26%;display:none;z-index:100;width:400px;height:140px;padding:2px;background-color:#fff;border:3px double #999;font-size:12px}.cmnt-popup .cmnt-btn {position:relative;padding:2px;text-align:left;background-color:#777;border:1px solid #ccc;border-bottom:1px solid #fff;color:#fff}.cmnt-popup .cmnt-btn span {display:inline-block;text-align:left}.cmnt-popup .cmnt-btn button {position:absolute;right:5px;top:3px;padding:0;text-align:center;width:16px;height:16px;font-size:10px;font-weight:bold;border:1px solid #fff}.cmnt-popup .cmnt-lst {height:120px;padding:2px;background-color:#fff;border:1px solid #ccc;text-align:left;line-height:16px;overflow:auto}.cmnt-red {left:22%;border:3px double blue;width:450px;font-size:14px;}.cmnt-red .cmnt-btn {background-color:blue;border:1px solid blue;}.cmnt-red .cmnt-btn span {font-weight:bold}.cmnt-red .cmnt-lst {height:150px;border:1px solid blue}/* 버튼 스타일 */.btn_bg {height:21px;border:1 solid #b1b1b1;background:url('/BizForce/EA/Images/btn_bg.gif');background-color:#ffffff; font-size:11px;letter-spacing:-1px;margin:0 2 0 2;padding:0 0 0 0 ;	vertical-align:middle;cursor:pointer}img.blt01 {margin:0 2 0 -2 ; vertical-align:middle;}.si-tbl img {margin:0px}/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */.m .ft {border:windowtext 1pt solid}.m .ft td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4 {text-align:center;background-color:#eeeeee}.m .ft input {height:20px}.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}.fm span {width:100%;text-align:left}.fm .fm-button {text-align:right}/* 본문 하위 테이블 */.m .ft-sub {border:windowtext 1pt solid;table-layout:}.m .ft-sub td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea {height:90%}.m .ft-sub input {height:20px}.m .ft-sub .ft-sub-sub {width:100%;border:0}.m .ft-sub .ft-sub-sub td {height:24px;word-break:break-all;border:0;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .ft-sub-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea,.m .ft-sub .ft-sub-sub textarea {height:90%}.m .ft-sub input,.m .ft-sub .ft-sub-sub input {height:20px}/* 첨부파일 */.m .fm-file table {height:100%}.m .fm-file td.file-title {vertical-align:top}.m .fm-file td.file-end {vertical-align:bottom;padding:0 0 3px 10px}.m .fm-file td.file-info {vertical-align:top}.m .fm-file td.file-info div {height:20px}/* 각종 필드 정의 - txt : input, txa : textarea */.m .txtText {ime-mode:active;width:100%;padding-top:1px}.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;padding-top:1px}.m .txtText_u {ime-mode:active;width:100%;border:0;border-bottom:1px solid #aaaaaa}.m .txaText {ime-mode:active;width:100%;overflow:auto}.m .txtNo {width:100%;padding-top:1px;padding-right:2;text-align:right}.m .txtNumberic, .m .txtVolume {width:100%;padding-top:1px;direction:rtl;padding-right:2;ime-mode:disabled}.m .txtJuminDash {width:100%;padding-top:1px;padding-right:2;text-align:center;ime-mode:disabled}.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollar3, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3 {direction:rtl;ime-mode:active;width:100%;padding-top:1px;padding-right:2;text-align:right;}.m .txtDate,.m .txtDateDot,.m .txtDateSlash,m .txtDateKo,.m .txtYear,.m .txtMonth,.m .txtHHmm,.m .txtHHmmss {ime-mode:disabled;width:100%;padding-top:1px;text-align:center;}.m .txtCalculate {ime-mode:active;width:100%;padding-top:1px;padding-right:2}.m .txaRead {width:100%;text-align:left}.m .txtRead {width:100%;border:0;padding-top:1px}.m .txtRead_Right {width:100%;border:0;padding-top:1px;padding-right:2;text-align:right}.m .txtRead_Center {width:100%;border:0;padding-top:1px;text-align:center}.m .ddlSelect {width:100%}.m .tdRead_Center {text-align:center}.m .tdRead_Right {text-align:right}/* 인쇄 설정 : 맨하단으로 */@media print {	.m .fb td a, .m .fm-file td a {text-decoration:none;color:#000000}	.m .fm-lines {padding-top:0}	.m .fm-lines .si-hdr td,.m .fm-lines .si-cur td,.si-tbl .si-title,.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4,.m .ft-sub .f-lbl-sub,.m .ft-sub .ft-sub-sub .f-lbl-sub {background-color:#ffffff} }";
    //return "html, body {margin:0px;padding:0px;width:100%}body {margin-bottom:2px;border:0;background-color:#ffffff;text-align:center;overflow:auto}.m,.m .ff,.m .fh,.m .fb,.m .fm,.m .fm1,.m .fm2,.m .fm3,.m .fm4,.m .fm-editor,.m .fm-lines {vertical-align:top}.m .ff {height:2px;font-size:1px}.m .fh {height:60px}.m .fb {height:80px}.m .fm-file,.m .fm-lines {text-align:left;}/* 폰트 */.fh h1 {font-family:굴림체;font-weight:bold}.si-tbl td {font-size:13px;font-family:맑은 고딕}.m .fm-lines .si-list td {font-size:12px;font-family:맑은 고딕}.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:13px;font-family:맑은 고딕}.m .ft-sub .ft-sub-sub td,.m .ft-sub .ft-sub-sub input,.m .ft-sub .ft-sub-sub select,.m .ft-sub .ft-sub-sub textarea,.m .ft-sub .ft-sub-sub div {font-size:13px;font-family:맑은 고딕}.m .fm span {font-size:14px;font-family:맑은 고딕}.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:13px;font-family:맑은 고딕}/* 로고 및 양식명 */.fh table {width:100%;height:100%}.fh .fh-l {width:150px;text-align:center}.fh .fh-m {padding-top:15px;text-align:center}.fh .fh-r {width:150px}.fh .fh-l img {border:0px solid red;vertical-align:middle;margin-top:0px}/* 결재칸 */.si-tbl {border:windowtext 1pt solid}.si-tbl td {vertical-align:middle;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid}.si-tbl .si-title {text-align:center;background-color:#eeeeee}.si-tbl .si-top {height:20px;text-align:center;padding-top:1px}.si-tbl .si-middle {height:65px;text-align:center}.si-tbl .si-bottom {height:20px;text-align:center}.si-tbl img {margin:0px}.m .fm-lines {padding-top:10px}.m .fm-lines table {width:100%;height:100%}.m .fm-lines .si-list {border:windowtext 1pt solid}.m .fm-lines .si-list td {text-align:center;height:24px;word-break:break-all;border-right:windowtext 0pt solid;border-bottom:windowtext 1pt solid}.m .fm-lines .si-subtd {border:0;padding-left:8px}.m .fm-lines .si-subtd .si-sublist {border:0;border-left:1px dotted windowtext}.m .fm-lines .si-subtd .si-sublist td {text-align:center;height:20px;word-break:break-all;border-right:windowtext 0pt dotted;border-bottom:windowtext 1pt dotted}.m .fm-lines .si-hdr td {background-color:#eeeeee}.m .fm-lines .si-cur td {background-color:#f7f3c1}.m .fm-lines .si-list .si-pname, .m .fm-lines .si-subtd .si-sublist .si-pname {text-align:left;padding-left:2px;padding-right:1px}.m .fm-lines .si-list .si-cmnt, .m .fm-lines .si-subtd .si-sublist .si-cmnt {text-align:left;padding:2px}/* 버튼 스타일 */.btn_bg {height:21px;border:1 solid #b1b1b1;background:url('/" + m_root + "/EA/Images/btn_bg.gif');background-color:#ffffff;font-size:11px;letter-spacing:-1px;margin:0 2 0 2;padding:0 0 0 0 ;	vertical-align:middle;cursor:pointer;}img.blt01 {margin:0 2 0 -2 ; vertical-align:middle;}.si-tbl img {margin:0px}/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */.m .ft {border:windowtext 1pt solid}.m .ft td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4 {text-align:center;background-color:#eeeeee}.m .ft input {height:20px}.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}.fm span {width:100%;text-align:left}.fm .fm-button {text-align:right}/* 본문 하위 테이블 */.m .ft-sub {border:windowtext 1pt solid;table-layout:}.m .ft-sub td {height:24px;word-break:break-all;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea {height:90%}.m .ft-sub input {height:20px}.m .ft-sub .ft-sub-sub {width:100%;border:0}.m .ft-sub .ft-sub-sub td {height:24px;word-break:break-all;border:0;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}.m .ft-sub .ft-sub-sub .f-lbl-sub {text-align:center;background-color:#eeeeee}.m .ft-sub textarea,.m .ft-sub .ft-sub-sub textarea {height:90%}.m .ft-sub input,.m .ft-sub .ft-sub-sub input {height:20px}/* 첨부파일 */.m .fm-file table {height:100%}.m .fm-file td.file-title {vertical-align:top}.m .fm-file td.file-end {vertical-align:bottom;padding:0 0 3px 10px}.m .fm-file td.file-info {vertical-align:top}.m .fm-file td.file-info div {height:20px}/* 각종 필드 정의 - txt : input, txa : textarea */.m .txtText {ime-mode:active;width:100%;padding-top:1px}.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;padding-top:1px}.m .txtText_u {ime-mode:active;width:100%;border:0;border-bottom:1px solid #aaaaaa}.m .txaText {ime-mode:active;width:100%;overflow:auto}.m .txtNo {width:100%;padding-top:1px;padding-right:2;text-align:right}.m .txtNumberic, .m .txtVolume {width:100%;padding-top:1px;direction:rtl;padding-right:2;ime-mode:disabled}.m .txtJuminDash {width:100%;padding-top:1px;padding-right:2;text-align:center;ime-mode:disabled}.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollar3, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3{direction:rtl;ime-mode:active;width:100%;padding-top:1px;padding-right:2;text-align:right;}.m .txtDate,.m .txtDateDot,.m .txtDateSlash,m .txtDateKo,.m .txtYear,.m .txtMonth,.m .txtHHmm,.m .txtHHmmss{ime-mode:disabled;width:100%;padding-top:1px;text-align:center;}.m .txtCalculate {ime-mode:active;width:100%;padding-top:1px;padding-right:2}.m .txaRead {width:100%;text-align:left}.m .txtRead {width:100%;border:0;padding-top:1px}.m .txtRead_Right {width:100%;border:0;padding-top:1px;padding-right:2;text-align:right}.m .txtRead_Center {width:100%;border:0;padding-top:1px;text-align:center}.m .ddlSelect {width:100%}.m .tdRead_Center {text-align:center}.m .tdRead_Right {text-align:right}/* 인쇄 설정 : 맨하단으로 */@media print {.m .fb td a, .m .fm-file td a {text-decoration:none;color:#000000}.m .fm-lines {padding-top:0}.m .fm-lines .si-hdr td,.m .fm-lines .si-cur td,.si-tbl .si-title,.m .ft .f-lbl,.m .ft .f-lbl1,.m .ft .f-lbl2,.m .ft .f-lbl3,.m .ft .f-lbl4,.m .ft-sub .f-lbl-sub,.m .ft-sub .ft-sub-sub .f-lbl-sub {background-color:#ffffff}}";
  }
  
  //특정 양식별로 필요한 경우
  function reportChart(nodes, pos, w, h, uY) {
    if (nodes.length == 0) return "";
    var p = null, c = null;
    var tw = "", th = "", tc = "", tsc = "", tdt = "", tls = "", tsw = "", lw = "", lc = "", ldt = "", nm = "";
    var rt = "", vlu = "", str = "";
    if (pos == "TOTAL") {
      p = nodes[0].selectSingleNode("row[CORPORATION='CT']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#666666"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#666666"; ldt = "";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str = renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CT(HS)']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#666666"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#666666"; ldt = "";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str = renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CT(ISM)']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = "#daa520"; tsc = "#8b4513"; tdt = ""; tls = ""; tsw = "2px"; lw = "1"; lc = "#8b4513"; ldt = "shortdashdotdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CH']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#a52a2a"; tdt = "shortdash"; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#a52a2a"; ldt = "shortdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CD']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = "#0000ff"; tsc = "#0000ff"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#0000ff"; ldt = "shortdashdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='IC']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#800080"; tdt = "shortdot"; tls = "thinthin"; tsw = "3px"; lw = "1"; lc = "#800080"; ldt = "dot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='IS']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#008000"; tdt = ""; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#008000"; ldt = "longdashdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CL']/TOTALSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#191970"; tdt = "shortdot"; tls = ""; tsw = "2px"; lw = "1"; lc = "#191970"; ldt = "longdashdotdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("sum/TOTALFAULTSUM");
      c = nodes[0].selectSingleNode("sum/TOTALSALESSUM");
      if (p && c && p.text != "" && c.text != "" && p.text != "0" && c.text != "0") {
        tw = "8"; th = "8"; tc = ""; tsc = ""; tdt = ""; tls = "thickthin"; tsw = "3px"; lw = "2"; lc = "#ff0000"; ldt = "solid";
        vlu = rate(p.text, c.text, 2);
        rt = vlu + ";" + "GROUP TOTAL 점유율 : " + vlu + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }      
      return str;

    } else if (pos == "TOTALBUY") {
      p = nodes[0].selectSingleNode("row[CORPORATION='CT']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#666666"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#666666"; ldt = "";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str = renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CH']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#a52a2a"; tdt = "shortdash"; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#a52a2a"; ldt = "shortdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CD']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = "#0000ff"; tsc = "#0000ff"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#0000ff"; ldt = "shortdashdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='IC']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#800080"; tdt = "shortdot"; tls = "thinthin"; tsw = "3px"; lw = "1"; lc = "#800080"; ldt = "dot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='IS']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#008000"; tdt = ""; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#008000"; ldt = "longdashdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      p = nodes[0].selectSingleNode("row[CORPORATION='CL']/TOTALBUYSHARE");
      if (p) {
        tw = "6"; th = "6"; tc = ""; tsc = "#191970"; tdt = "shortdot"; tls = ""; tsw = "2px"; lw = "1"; lc = "#191970"; ldt = "longdashdotdot";
        rt = p.text + ";" + "CCT TOTAL 점유율 : " + p.text + "%";
        str += renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
      }
      p = null;
      return str;

    } else if (pos == "GROUP") {
      tw = "6"; th = "6"; tc = ""; tsc = ""; tdt = ""; tls = "thickthin"; tsw = "3px"; lw = "2"; lc = "#ff0000"; ldt = "solid";
      for (var i=1; i<=12; i++) {
        if (i>1) rt += "^";
        p = nodes[0].selectSingleNode("sum/FAULTSUM" + i.toString());
        c = nodes[0].selectSingleNode("sum/SALESSUM" + i.toString());
        if (p && c && p.text != "" && c.text != "" && p.text != "0" && c.text != "0") {vlu = rate(p.text, c.text, 2); rt += vlu + ";" + pos + " " + i.toString() + "월 점유율 : " + vlu + "%";}
        else rt += ";"
      }
      return renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
    } else {
      if (pos == "CT" || pos == "CT(HS)") {tw = "6"; th = "6"; tc = ""; tsc = "#666666"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#666666"; ldt = "";}
      else if (pos == "CT(ISM)") {tw = "6"; th = "6"; tc = "#daa520"; tsc = "#8b4513"; tdt = ""; tls = ""; tsw = "2px"; lw = "1"; lc = "#8b4513"; ldt = "shortdashdotdot";}
      else if (pos == "CH") {tw = "6"; th = "6"; tc = ""; tsc = "#a52a2a"; tdt = "shortdash"; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#a52a2a"; ldt = "shortdot";}
      else if (pos == "CD") {tw = "6"; th = "6"; tc = "#0000ff"; tsc = "#0000ff"; tdt = ""; tls = ""; tsw = ""; lw = "1"; lc = "#0000ff"; ldt = "shortdashdot";}
      else if (pos == "IC") {tw = "6"; th = "6"; tc = ""; tsc = "#800080"; tdt = "shortdot"; tls = "thinthin"; tsw = "3px"; lw = "1"; lc = "#800080"; ldt = "dot";}
      else if (pos == "IS") {tw = "6"; th = "6"; tc = ""; tsc = "#008000"; tdt = ""; tls = "thinthin"; tsw = "2px"; lw = "1"; lc = "#008000"; ldt = "longdashdot";}
      else if (pos == "CL") {tw = "6"; th = "6"; tc = ""; tsc = "#191970"; tdt = "shortdot"; tls = ""; tsw = "2px"; lw = "1"; lc = "#191970"; ldt = "longdashdotdot";}
      else if (pos == "VH") {tw = "6"; th = "6"; tc = ""; tsc = "#999"; tdt = ""; tls = ""; tsw = "1px"; lw = "1"; lc = "#999"; ldt = "solid";}
      
      nm = (arguments[5] && arguments[5] != '') ? arguments[5] : "SHARE";
      p = nodes[0].selectNodes("row[CORPORATION='" + pos + "']");
      if (p.length == 0) return "";
      for (var i=1; i<=12; i++) {
        c = p[0].selectSingleNode(nm + i.toString());        
        if (i>1) rt += "^";
        if (c) rt += c.text + ";" + pos + " " + i.toString() + "월 점유율 : " + c.text + "%";
        else rt += ";"
      }
      return renderLineSpecialChart(rt, w, h, uY, tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt);
    }
  }
  
  function round(val,precision) { if (val == '') {return 0;} else {val = val * Math.pow(10,precision); val = Math.round(val); return val/Math.pow(10,precision);} }
  
  function calcAxisHeight(h, std, y) {if (y < 0) y = parseFloat(y.toString().replace('-', '')); return round(parseFloat(h * y / std), 0);}  
  function calcAxisY(max) {
    if (max == 0) return 0;
    if (max < 0) max = parseFloat(max.toString().replace('-', ''));
  
    //차트 높이-10 => 상단 표시 값 위치
    var dStd = 0, dInteval = 0, n = 10, bOut = false;
    
    for (var i = 1; i <= 7; i++) {
      dInteval = (i > 1) ? Math.pow(n, i - 1) : Math.pow(n, i);

      for (var j = Math.pow(n, i); j <= Math.pow(n, i + 1); j += dInteval) {
        if (max < j) {
          dStd = j; bOut = true; break;
        }
      }
      if (bOut) break;
    }
    return dStd;
  }
  
  function renderChart(ft, pos, h, nodes, std, etc) {
    var s = '', s2 = '';
    if (nodes.length > 0) {
      var vPrev = ['', '', '', '', '', '', '', '', '', '', '', ''], vStd = ['', '', '', '', '', '', '', '', '', '', '', ''];
      var d = 1000, iPrev = 0, iStd = 0, iMax = 0, iMin = 0, sH = 0, sH2 = 0, t = 0;
      
      var nPoint = etc == 'VU' ? 2 : 0;
        
      if (ft == 'MONTHFAULTYGOODS') {
        for(var x = 0; x < nodes.length; x++) {
          if (parseInt(nodes[x].selectSingleNode("STATSYEAR").text) == parseInt(std) - 1) {
            if (vPrev[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] == '') vPrev[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] = 0;
            vPrev[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] += round(parseFloat(nodes[x].selectSingleNode("TGTVALUE").text) / d, nPoint);
          } else if (parseInt(nodes[x].selectSingleNode("STATSYEAR").text) == parseInt(std)) {
            if (vStd[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] == '') vStd[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] = 0;
            vStd[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] += round(parseFloat(nodes[x].selectSingleNode("TGTVALUE").text) / d, nPoint);
          }
        }
        
        //return nodes.length + " : " + vPrev.length;
        
        for (var x in vPrev) iPrev += vPrev[x] == '' ? 0 : vPrev[x];
        for (var x in vStd) iStd += vStd[x] == '' ? 0 : vStd[x];
        
        if (pos == 'chart') {
          iMax = iPrev > iStd ? iPrev : iStd;
          for (var x in vStd) {
            var v = vStd[x] == '' ? 0 : parseFloat(vStd[x]);
            if (v > iMax) iMax = v;
          }
          
          iMax = round(iMax * 1.1, 0); //10% 정도 높임
          sH = calcAxisY(iMax);
          
          //return sH + " : " + iPrev + " : " + iStd;
          
          s = '<td class="axis-y">';
          s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h, sH, sH) - 8) + 'px">' + addComma(sH.toString()) + '</div>';
          s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h, sH, (sH * 3 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 3 / 4).toFixed(0).toString()) + '</div>';
          s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h, sH, (sH * 2 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 2 / 4).toFixed(0).toString()) + '</div>';
          s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h, sH, (sH * 1 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 1 / 4).toFixed(0).toString()) + '</div>';
          s += '<div class="zero" style="bottom: 0">0</div>';
          
          s += '</td><td class="fc-plus">'; //전년
          t = calcAxisHeight(h, sH, iPrev);
          s += '<div class="bar prev" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 4) + 'px">' + addCommaAndDotMinus(iPrev.toString(), nPoint) + '</div>';

          s += '</td><td class="fc-plus">'; //금년
          t = calcAxisHeight(h, sH, iStd);
          s += '<div class="bar now" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 4) + 'px">' + addCommaAndDotMinus(iStd.toString(), nPoint) + '</div>';
          s += '</td>';
          
          for (var x in vStd) { 
            s += '<td class="fc-plus">';
            t = calcAxisHeight(h, sH, vStd[x]);
            if (parseInt(t) > 0) s += '<div class="bar" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 4) + 'px">' + addCommaAndDotMinus(vStd[x].toString(), nPoint) + '</div>';
            s += '</td>';
          }
          s += '<td class=""></td>';
        
        } else if (pos == 'table') {
          s = '<td style="text-align: center; border-bottom:0">K USD</td>';
          s += '<td style="text-align: center; border-bottom:0">' + addCommaAndDotMinus(iPrev.toString(), nPoint) + '</td>';
          s += '<td style="text-align: center; border-bottom:0">' + addCommaAndDotMinus(iStd.toString(), nPoint) + '</td>';
          for (var x in vStd) {
            if (x == vStd.length - 1) s += '<td style="text-align: center; border-bottom:0; border-right:0">' + (vStd[x].toString() == '' ? '&nbsp;' : addCommaAndDotMinus(vStd[x].toString(), nPoint)) + '</td>';
            else s += '<td style="text-align: center; border-bottom:0">' + (vStd[x].toString() == '' ? '&nbsp;' : addCommaAndDotMinus(vStd[x].toString(), nPoint)) + '</td>';
          }
        }
        return s;
      
      } else {
        d = 1;
        
        for(var x = 0; x < nodes.length; x++) {
          if (parseInt(nodes[x].selectSingleNode("STATSYEAR").text) == parseInt(std) - 1) {
            vPrev[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] = round(parseFloat(nodes[x].selectSingleNode("TGTVALUE").text) / d, 0);
          } else if (parseInt(nodes[x].selectSingleNode("STATSYEAR").text) == parseInt(std)) {
            vStd[parseInt(nodes[x].selectSingleNode("STATSMONTH").text) - 1] = round(parseFloat(nodes[x].selectSingleNode("TGTVALUE").text) / d, 0);
          }
        }
        
        //return vPrev.toString() + " : " + vStd.toString();
        
        for (var x in vPrev) iPrev += vPrev[x] == '' ? 0 : vPrev[x];
        for (var x in vStd) iStd += vStd[x] == '' ? 0 : vStd[x];
        
        if (pos == 'chart') {
          iMax = iPrev > iStd ? iPrev : iStd;
          iMin = iPrev > iStd ? iStd : iPrev;
          
          //return  iMin + " : " + sH2 + " : " + iMax
          
          for (var x in vStd) {
            var v = vStd[x] == '' ? 0 : parseFloat(vStd[x]);
            if (v > iMax) iMax = v;
            else if (v < iMin) iMin = v;
          }
          
          //return  iMin + " : " + sH2 + " : " + iMax
          
          iMax = round(iMax * 1.1, 0); //10% 정도 높임
          iMin = round(iMin * 1.1, 0); //10% 정도 높임
          sH = calcAxisY(iMax);
          sH2 = calcAxisY(iMin);
          
          var plusH = 0, h2 = h, h3 = h;
          if (iMax > 0 && iMin < 0) {
            plusH = round(sH * 100 / (sH + sH2), 0);
            if (plusH < 10) plusH = 10;
            else if (plusH > 85) plusH = 85;
          }
          
          if (plusH > 0) {
            h2 = (h * plusH / 100).toFixed(0);
            h3 = (h * (100 - plusH) / 100).toFixed(0);
          }
          
          //return plusH + " : "+ h2 + " : " + h3 + " : " + iMax + " : " + sH2 + " : " + iMin + " : " + iPrev + " : " + iStd;
          
          if (iMax > 0) {
            s = '<tr>'
            s += '<td class="axis-y" style="height: ' + (plusH > 0 ? plusH + '%' : '') + '">';
            if (plusH > 70) {
              s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h2, sH, sH) - 8) + 'px">' + addComma(sH.toString()) + '</div>';
              s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h2, sH, (sH * 3 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 3 / 4).toFixed(0).toString()) + '</div>';
              s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h2, sH, (sH * 2 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 2 / 4).toFixed(0).toString()) + '</div>';
              s += '<div class="plus" style="bottom: ' + (calcAxisHeight(h2, sH, (sH * 1 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH * 1 / 4).toFixed(0).toString()) + '</div>';
              //s += '<div class="zero" style="bottom: 0">0</div>';
            
            } else {
              t = calcAxisHeight(h2, sH, sH);
              s += '<div class="plus" style="bottom: ' + (parseInt(t) - 8 < 18 ? '18' : (parseInt(t) - 8)) + 'px">' + addComma(sH.toString()) + '</div>';
            }
            
            s += '</td><td class="fc-plus">'; //전년
            if (iPrev > 0) {
              t = calcAxisHeight(h2, sH, iPrev);
              s += '<div class="bar prev" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 2) + 'px">' + addComma(iPrev.toString()) + '</div>';
            }
            
            s += '</td><td class="fc-plus">'; //금년
            if (iStd > 0) {
              t = calcAxisHeight(h2, sH, iStd);
              s += '<div class="bar now" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 2) + 'px">' + addComma(iStd.toString()) + '</div>';
            }
            s += '</td>';
            
            for (var x in vStd) { 
              s += '<td class="fc-plus">';
              if (parseFloat(vStd[x]) > 0) {
                t = calcAxisHeight(h2, sH, vStd[x]);
                if (parseInt(t) > 0) s += '<div class="bar" style="height: ' + t + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t) + 2) + 'px">' + addComma(vStd[x].toString()) + '</div>';
              }
              s += '</td>';
            }
            //s += '<td class=""></td>';
            s += '</tr>';
          }
          
          if (iMin < 0) {
            s += '<tr><td></td><td class="fc-zero border" colspan="14">&nbsp;</td></tr>';
            
            s += '<tr>'
            s += '<td class="axis-y">';
            s += '<div class="zero" style="top: 0">0</div>';
            if (plusH < 30) {
              s += '<div class="minus" style="top: ' + (calcAxisHeight(h3, sH2, sH2) - 8) + 'px">' + addComma(sH2.toString()) + '</div>';
              s += '<div class="minus" style="top: ' + (calcAxisHeight(h3, sH2, (sH2 * 3 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH2 * 3 / 4).toFixed(0).toString()) + '</div>';
              s += '<div class="minus" style="top: ' + (calcAxisHeight(h3, sH2, (sH2 * 2 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH2 * 2 / 4).toFixed(0).toString()) + '</div>';
              s += '<div class="minus" style="top: ' + (calcAxisHeight(h3, sH2, (sH2 * 1 / 4).toFixed(0)) - 8) + 'px">' + addComma((sH2 * 1 / 4).toFixed(0).toString()) + '</div>';
            
            } else {
              t = calcAxisHeight(h3, sH2, sH2);
              s += '<div class="minus" style="top: ' + (t < 20 ? '20' : (parseInt(t) - 4)) + 'px">' + addComma(sH2.toString()) + '</div>';
            }
            
            s += '</td><td class="fc-minus">'; //전년
            if (iPrev < 0) {
              t = calcAxisHeight(h3, sH2, iPrev);
              s += '<div class="lbl">전년</div><div class="bar prev" style="height: ' + t + 'px"></div><div class="lbl-value" style="top: ' + (parseInt(t) < 20 ? 20 : parseInt(t)) + 'px">' + addCommaAndDotMinus(iPrev.toString()) + '</div>';
            }
            
            s += '</td><td class="fc-minus">'; //금년
            if (iStd < 0) {
              t = calcAxisHeight(h3, sH2, iStd);
              s += '<div class="lbl">금년</div><div class="bar now" style="height: ' + t + 'px"></div><div class="lbl-value" style="top: ' + (parseInt(t) < 20 ? 20 : parseInt(t)) + 'px">' + addCommaAndDotMinus(iStd.toString()) + '</div>';
            }
            s += '</td>';
            
            for (var x in vStd) { 
              s += '<td class="fc-minus"><div class="lbl">' + (parseInt(x) + 1).toString() + '월</div>';
              if (parseFloat(vStd[x]) < 0) {
                t = calcAxisHeight(h3, sH2, vStd[x]);
                if (parseFloat(vStd[x]) < 0) s += '<div class="bar" style="height: ' + t + 'px"></div><div class="lbl-value" style="top: ' + (parseInt(t) < 20 ? 20 : parseInt(t)) + 'px">' + addCommaAndDotMinus(vStd[x].toString()) + '</div>';
              }
              s += '</td>';
            }
            //s += '<td class=""></td>';
            s += '</tr>';
          }
        
        } else if (pos == 'table') {
          s = '<td style="text-align: center; border-bottom:0">USD</td>';
          s += '<td style="text-align: center; border-bottom:0">' + addCommaAndDotMinus(iPrev.toString()) + '</td>';
          s += '<td style="text-align: center; border-bottom:0">' + addCommaAndDotMinus(iStd.toString()) + '</td>';
          for (var x in vStd) {
            if (vStd[x] != '') {
              if (x == vStd.length - 1) s += '<td style="text-align: center; border-bottom:0; border-right:0">' + addCommaAndDotMinus(vStd[x].toString()) + '</td>';
              else s += '<td style="text-align: center; border-bottom:0">' + addCommaAndDotMinus(vStd[x].toString()) + '</td>';
            } else {
              if (x == vStd.length - 1) s += '<td style="text-align: center; border-bottom:0; border-right:0">&nbsp;</td>';
              else s += '<td style="text-align: center; border-bottom:0">&nbsp;</td>';
            }
          }
        }
        return s;
      }
    }
  }
	]]>
  </msxsl:script>
</xsl:stylesheet>