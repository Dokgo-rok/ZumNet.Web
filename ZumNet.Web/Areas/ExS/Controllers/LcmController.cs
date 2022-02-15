using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class LcmController : Controller
    {
        #region [메인, 목록]
        // GET: ExS/Lcm
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath;
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //권한, 초기 설정 가져오기
            rt = Bc.CtrlHandler.LcmInit(this);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission;
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //검색
            string sSearchText = "";
            if (ViewBag.R.lv["search"].ToString() != "" && ViewBag.R.lv["searchtext"].ToString() != "")
            {
                if (ViewBag.R.lv["search"].ToString() == "_INST_") sSearchText = " AND (InstDN LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%' OR InstructorInfo1 LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%' OR Instructor LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%')";
                else sSearchText = " AND " + ViewBag.R.lv["search"].ToString() + " LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%'";
            }

            using (ZumNet.BSL.InterfaceBiz.ReportBiz rpt = new BSL.InterfaceBiz.ReportBiz())
            {
                svcRt = rpt.GetReport(ViewBag.R.mode.ToString(), StringHelper.SafeInt(ViewBag.R.lv["tgt"]), ViewBag.R.ft.ToString()
                                , ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString(), ViewBag.R.lv["cd1"].ToString()
                                , StringHelper.SafeString(ViewBag.R.lv["cd2"]), StringHelper.SafeString(ViewBag.R.lv["cd3"])
                                , StringHelper.SafeString(ViewBag.R.lv["cd4"]), StringHelper.SafeString(ViewBag.R.lv["cd5"])
                                , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["basesort"].ToString()
                                , ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString(), sSearchText);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.Mode = ViewBag.R.mode.ToString();
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

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    string formTable = jPost["ft"].ToString();

                    //권한, 초기 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.LcmInit(this);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "310";
                    if (jPost["current"]["operator"].ToString() == "N" && (jPost["current"]["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(jPost["current"]["acl"].ToString(), "V")))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    //string sCmd = "";

                    //검색
                    string sSearchText = "";
                    if (jPost["lv"]["search"].ToString() != "" && jPost["lv"]["searchtext"].ToString() != "")
                    {
                        if (jPost["lv"]["search"].ToString() == "_INST_") sSearchText = " AND (InstDN LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%' OR InstructorInfo1 LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%' OR Instructor LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%')";
                        else sSearchText = " AND " + jPost["lv"]["search"].ToString() + " LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%'";
                    }

                    sPos = "410";
                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpt = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpt.GetReport(ViewBag.R.mode.ToString(), Convert.ToInt32(jPost["lv"]["tgt"]), jPost["ft"].ToString()
                                        , jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString(), jPost["lv"]["cd1"].ToString()
                                        , StringHelper.SafeString(jPost["lv"]["cd2"]), StringHelper.SafeString(jPost["lv"]["cd3"])
                                        , StringHelper.SafeString(jPost["lv"]["cd4"]), StringHelper.SafeString(jPost["lv"]["cd5"])
                                        , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"]), jPost["lv"]["basesort"].ToString()
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), sSearchText);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";
                        ViewBag.Mode = ViewBag.R.mode.ToString();
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "510";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListCount", ViewBag);
                    }
                    else
                    {
                        rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }

            return rt;
        }
        #endregion
    }
}