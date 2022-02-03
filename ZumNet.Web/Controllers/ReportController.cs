using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class ReportController : Controller
    {
        // GET: Report
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);
            int iFolderId = StringHelper.SafeInt(ViewBag.R.fdid.Value);
            string formTable = ViewBag.R.ft.ToString();

            ViewBag.R.lv["page"] = "1";
            ViewBag.R.lv["count"] = Bc.CommonUtils.GetLvCookie("doc").ToString();

            //초기 설정
            rt = Bc.CtrlHandler.ReportInit(this, iCategoryId, iFolderId, Request["qi"].ToString());
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ZumNet.Framework.Util.StringHelper.SafeString(ViewBag.R.ttl) == "")
            {
                //Title이 빈값인 경우(Ajax로 불러온 경우 ttl=''로 설정, 이후 로그아웃 되어 returnUrl로 넘어 왔을 때)
                rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                if (rt != "")
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            //검색 조건
            string strWhere = "";
            if (formTable == "REGISTER_TOOLING")
            {
                if (ViewBag.R.lv.cd1.ToString() != "") strWhere += " AND DIVISION = '" + ViewBag.R.lv.cd1.ToString() + "'";             //제작구분
                if (ViewBag.R.lv.cd2.ToString() != "") strWhere += " AND CLASSIFICATION_ID = '" + ViewBag.R.lv.cd2.ToString() + "'";    //금형분류
                if (ViewBag.R.lv.cd3.ToString() != "") strWhere += " AND WHO_MONEY = N'" + ViewBag.R.lv.cd3.ToString() + "'";           //금형비부담
                if (ViewBag.R.lv.cd4.ToString() != "") strWhere += " AND TOOLING_NUMBER LIKE '" + ViewBag.R.lv.cd4.ToString() + "%'";   //금형번호
                if (ViewBag.R.lv.cd5.ToString() != "") strWhere += " AND MODELNO LIKE '%" + ViewBag.R.lv.cd5.ToString() + "%'";         //적용모델
                if (ViewBag.R.lv.cd6.ToString() != "")
                {
                    strWhere += " AND USAGE_TYPE = '" + ViewBag.R.lv.cd6.ToString() + "'";  //2016-04-27 USAGE_TYPE 필드값 정리 이후
                }

                if (ViewBag.R.lv.cd7.ToString() != "") strWhere += " AND TOOLING_TAGNO LIKE '%" + ViewBag.R.lv.cd7.ToString() + "%'";           //고객금형번호
                if (ViewBag.R.lv.cd8.ToString() != "") strWhere += " AND PARTNO LIKE '%" + ViewBag.R.lv.cd8.ToString() + "%'";                  //품번
                if (ViewBag.R.lv.cd9.ToString() != "") strWhere += " AND ORG_NAME = '" + ViewBag.R.lv.cd9.ToString() + "'";                     //사업장
                if (ViewBag.R.lv.cd10.ToString() != "") strWhere += " AND BUYER_NAME LIKE N'%" + ViewBag.R.lv.cd10.ToString() + "%'";           //BUYER
                if (ViewBag.R.lv.cd12.ToString() != "") strWhere += " AND MAKE_SUPPLIER_NAME LIKE N'%" + ViewBag.R.lv.cd12.ToString() + "%'";   //제작처
                if (ViewBag.R.lv.cd11.ToString() != "") strWhere += " AND (DEPT_NAME LIKE N'%" + ViewBag.R.lv.cd11.ToString() + "%' OR CHARGE_USER LIKE N'%" + ViewBag.R.lv.cd11.ToString() + "%')"; //영업부서, 담당자

                if (ViewBag.R.lv.start.ToString().Trim() != "") strWhere += " AND DATEDIFF(DD, '" + ViewBag.R.lv.start.ToString() + "', ORDER_CREATE_DATE) >= 0 "; //2014-04-16 CREATE_DATE=>ORDER_CREATE_DATE
                if (ViewBag.R.lv.end.ToString().Trim() != "") strWhere += " AND DATEDIFF(DD, ORDER_CREATE_DATE, '" + ViewBag.R.lv.end.ToString() + "') >= 0 ";
            }
            else if (formTable == "FORM_NEWDEVELOPREQUEST" || formTable == "REPORT_DEVPRODUCTSTATE" || formTable == "REGISTER_FOURMAFTERSERVICE")
            {
                if (formTable == "REPORT_DEVPRODUCTSTATE") ViewBag.R.lv["cd3"] = "DSESTART";
                else if (formTable == "REGISTER_FOURMAFTERSERVICE") ViewBag.R.lv["cd3"] = "S_CDT"; //작성일
                else ViewBag.R.lv["cd3"] = "PublishDate";

                ViewBag.R.lv["cd4"] = ViewBag.R.lv.sort.ToString();
                ViewBag.R.lv["cd5"] = ViewBag.R.lv.sortdir.ToString();
            }
            else
            {
                if (formTable == "REGISTER_ECNPLAN" || formTable == "REGISTER_ECNPLAN_DELAY" || formTable == "BFFLOW_MONITORING_DEPT")
                {
                    ViewBag.R.lv["cd4"] = ViewBag.R.lv.sort.ToString();
                    ViewBag.R.lv["cd5"] = ViewBag.R.lv.sortdir.ToString();
                }
            }

            using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
            {
                if (formTable == "REGISTER_TOOLING")
                {
                    svcRt = rpBiz.GetReport(ViewBag.R.mode.ToString(), StringHelper.SafeInt(ViewBag.R.lv.tgt.Value), formTable, ViewBag.R.lv.start.ToString(), ViewBag.R.lv.end.ToString()
                                    , "", "", "", "", ""
                                    , StringHelper.SafeInt(ViewBag.R.lv.page.Value), StringHelper.SafeInt(ViewBag.R.lv.count.Value), ViewBag.R.lv.basesort.ToString()
                                    , ViewBag.R.lv.sort.ToString(), ViewBag.R.lv.sortdir.ToString(), ViewBag.R.lv.searchtext.ToString());
                }
                else if (formTable == "SEARCH_EADOC")
                {

                }
                else
                {
                    svcRt = rpBiz.GetReport(ViewBag.R.mode.ToString(), StringHelper.SafeInt(ViewBag.R.lv.tgt.Value), formTable, ViewBag.R.lv.start.ToString(), ViewBag.R.lv.end.ToString()
                                    , ViewBag.R.lv.cd1.ToString(), ViewBag.R.lv.cd2.ToString(), ViewBag.R.lv.cd3.ToString(), ViewBag.R.lv.cd4.ToString(), ViewBag.R.lv.cd5.ToString());
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataSet;
                ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Index()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (rt == "")
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    int iFolderId = Convert.ToInt32(jPost["fdid"]);
                    string formTable = jPost["ft"].ToString();

                    //초기 설정
                    sPos = "300";
                    rt = Bc.CtrlHandler.ReportInit(this, iCategoryId, iFolderId, Request["qi"].ToString());
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    //검색 조건
                    sPos = "400";
                    string strWhere = "";
                    if (formTable == "REGISTER_TOOLING")
                    {
                        if (jPost["lv"]["cd1"].ToString() != "") strWhere += " AND DIVISION = '" + jPost["lv"]["cd1"].ToString() + "'";             //제작구분
                        if (jPost["lv"]["cd2"].ToString() != "") strWhere += " AND CLASSIFICATION_ID = '" + jPost["lv"]["cd2"].ToString() + "'";    //금형분류
                        if (jPost["lv"]["cd3"].ToString() != "") strWhere += " AND WHO_MONEY = N'" + jPost["lv"]["cd3"].ToString() + "'";           //금형비부담
                        if (jPost["lv"]["cd4"].ToString() != "") strWhere += " AND TOOLING_NUMBER LIKE '" + jPost["lv"]["cd4"].ToString() + "%'";   //금형번호
                        if (jPost["lv"]["cd5"].ToString() != "") strWhere += " AND MODELNO LIKE '%" + jPost["lv"]["cd5"].ToString() + "%'";         //적용모델
                        if (jPost["lv"]["cd6"].ToString() != "")
                        {
                            strWhere += " AND USAGE_TYPE = '" + jPost["lv"]["cd6"].ToString() + "'";  //2016-04-27 USAGE_TYPE 필드값 정리 이후
                        }

                        if (jPost["lv"]["cd7"].ToString() != "") strWhere += " AND TOOLING_TAGNO LIKE '%" + jPost["lv"]["cd7"].ToString() + "%'";           //고객금형번호
                        if (jPost["lv"]["cd8"].ToString() != "") strWhere += " AND PARTNO LIKE '%" + jPost["lv"]["cd8"].ToString() + "%'";                  //품번
                        if (jPost["lv"]["cd9"].ToString() != "") strWhere += " AND ORG_NAME = '" + jPost["lv"]["cd9"].ToString() + "'";                     //사업장
                        if (jPost["lv"]["cd10"].ToString() != "") strWhere += " AND BUYER_NAME LIKE N'%" + jPost["lv"]["cd10"].ToString() + "%'";           //BUYER
                        if (jPost["lv"]["cd12"].ToString() != "") strWhere += " AND MAKE_SUPPLIER_NAME LIKE N'%" + jPost["lv"]["cd12"].ToString() + "%'";   //제작처
                        if (jPost["lv"]["cd11"].ToString() != "") strWhere += " AND (DEPT_NAME LIKE N'%" + jPost["lv"]["cd11"].ToString() + "%' OR CHARGE_USER LIKE N'%" + jPost["lv"]["cd11"].ToString() + "%')"; //영업부서, 담당자

                        if (jPost["lv"]["start"].ToString().Trim() != "") strWhere += " AND DATEDIFF(DD, '" + jPost["lv"]["start"].ToString() + "', ORDER_CREATE_DATE) >= 0 "; //2014-04-16 CREATE_DATE=>ORDER_CREATE_DATE
                        if (jPost["lv"]["end"].ToString().Trim() != "") strWhere += " AND DATEDIFF(DD, ORDER_CREATE_DATE, '" + jPost["lv"]["end"].ToString() + "') >= 0 ";
                    }
                    else if (formTable == "FORM_NEWDEVELOPREQUEST" || formTable == "REPORT_DEVPRODUCTSTATE" || formTable == "REGISTER_FOURMAFTERSERVICE")
                    {
                        if (formTable == "REPORT_DEVPRODUCTSTATE") jPost["lv"]["cd3"] = "DSESTART";
                        else if (formTable == "REGISTER_FOURMAFTERSERVICE") jPost["lv"]["cd3"] = "S_CDT"; //작성일
                        else jPost["lv"]["cd3"] = "PublishDate";

                        jPost["lv"]["cd4"] = jPost["lv"]["sort"].ToString();
                        jPost["lv"]["cd5"] = jPost["lv"]["sortdir"].ToString();
                    }
                    else
                    {
                        if (formTable == "REGISTER_ECNPLAN" || formTable == "REGISTER_ECNPLAN_DELAY" || formTable == "BFFLOW_MONITORING_DEPT")
                        {
                            jPost["lv"]["cd4"] = jPost["lv"]["sort"].ToString();
                            jPost["lv"]["cd5"] = jPost["lv"]["sortdir"].ToString();
                        }
                    }

                    sPos = "500";
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        if (formTable == "REGISTER_TOOLING")
                        {
                            svcRt = rpBiz.GetReport(jPost["mode"].ToString(), StringHelper.SafeInt(jPost["lv"]["tgt"].ToString()), formTable, jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString()
                                            , "", "", "", "", ""
                                            , StringHelper.SafeInt(jPost["lv"]["page"].ToString()), StringHelper.SafeInt(jPost["lv"]["count"].ToString()), jPost["lv"]["basesort"].ToString()
                                            , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["searchtext"].ToString());
                        }
                        else if (formTable == "SEARCH_EADOC")
                        {

                        }
                        else
                        {
                            svcRt = rpBiz.GetReport(jPost["mode"].ToString(), StringHelper.SafeInt(jPost["lv"]["tgt"].ToString()), formTable, jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString()
                                            , jPost["lv"]["cd1"].ToString(), jPost["lv"]["cd2"].ToString(), jPost["lv"]["cd3"].ToString(), jPost["lv"]["cd4"].ToString(), jPost["lv"]["cd5"].ToString());
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "510";
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "520";
                        string sPatialView = "_" + formTable;
                        if (!System.IO.File.Exists(Server.MapPath("~/Views/Report/" + sPatialView + ".cshtml")))
                        {
                            sPatialView = "_ListCommon";
                        }

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, sPatialView, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListMenu", ViewBag)
                                +jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListPagination", ViewBag);
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }

            return rt;
        }
    }
}