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
    public class PQmController : Controller
    {
        // GET: ExS/PQm
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

            ViewBag.R["lv"]["start"] = StringHelper.SafeString(ViewBag.R["lv"]["start"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"));
            if (formTable == "INVKPI")
            {
                using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                {
                    svcRt = pqmBiz.Get_INV_NEW_KPI("A", ViewBag.R["lv"]["start"].ToString(), "0", 0);
                }
            }
            else if (formTable == "INVKPI_S")
            {
                using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                {
                    svcRt = pqmBiz.Get_INV_NEW_KPI_S("A", ViewBag.R["lv"]["start"].ToString(), "0", 0);
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataSet;
                ViewBag.Mode = "";
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
                    jPost["lv"]["start"] = StringHelper.SafeString(jPost["lv"]["start"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"));

                    //초기 설정
                    sPos = "300";
                    rt = Bc.CtrlHandler.ReportInit(this, iCategoryId, iFolderId, Request["qi"].ToString());
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    if (formTable == "INVKPI")
                    {
                        sPos = "400";
                        using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                        {
                            svcRt = pqmBiz.Get_INV_NEW_KPI("A", jPost["lv"]["start"].ToString(), "0", 0);
                        }
                    }
                    else if (formTable == "INVKPI_S")
                    {
                        sPos = "410";
                        using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                        {
                            svcRt = pqmBiz.Get_INV_NEW_KPI_S("A", jPost["lv"]["start"].ToString(), "0", 0);
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "510";
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.Mode = "ajax";

                        sPos = "520";

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag);
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string KpiTable()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["ft"]) == "" || StringHelper.SafeString(jPost["year"]) == "" || StringHelper.SafeString(jPost["week"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost["ft"].ToString() == "INVKPI")
                    {
                        using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                        {
                            svcRt = pqmBiz.Get_INV_NEW_KPI("T", DateTime.Now.ToString("yyyy-MM-dd"), jPost["year"].ToString(), StringHelper.SafeInt(jPost["week"]));
                        }
                    }
                    else if (jPost["ft"].ToString() == "INVKPI_S")
                    {
                        using (ZumNet.BSL.InterfaceBiz.PQmBiz pqmBiz = new BSL.InterfaceBiz.PQmBiz())
                        {
                            svcRt = pqmBiz.Get_INV_NEW_KPI_S("T", DateTime.Now.ToString("yyyy-MM-dd"), jPost["year"].ToString(), StringHelper.SafeInt(jPost["week"]));
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.Mode = "table";

                        strView = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + jPost["ft"].ToString(), ViewBag);
                    }
                    else
                    {
                        strView = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }
    }
}