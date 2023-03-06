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
    public class NumController : Controller
    {
        // GET: ExS/Num
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
            string formTable = ViewBag.R.ft == null || ViewBag.R.ft.ToString() == "" ? "NUM_ME" : ViewBag.R.ft.ToString();

            //초기 설정
            rt = Bc.CtrlHandler.NumInit(this, iCategoryId, iFolderId, formTable);
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
            ViewBag.Mode = "";

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
                    int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);
                    int iFolderId = StringHelper.SafeInt(ViewBag.R.fdid.Value);
                    string formTable = ViewBag.R.ft.ToString();

                    //초기 설정
                    sPos = "200";
                    rt = Bc.CtrlHandler.NumInit(this, iCategoryId, iFolderId, formTable);
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    sPos = "300";
                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
                    {
                        return Resources.Global.Auth_NoPermission;
                    }

                    ViewBag.Mode = "ajax";

                    sPos = "400";
                    rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                                + ViewBag.R["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListMenu", ViewBag)
                                + ViewBag.R["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListPagination", ViewBag);
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }

            return rt;
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult Sheet(string Qi)
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
            string formTable = ViewBag.R.ft == null || ViewBag.R.ft.ToString() == "" ? "NUM_ME" : ViewBag.R.ft.ToString();

            //초기 설정
            rt = Bc.CtrlHandler.NumInit(this, iCategoryId, iFolderId, formTable);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new ZumNet.BSL.InterfaceBiz.ReportBiz())
            {
                svcRt = rpBiz.GetRegisterNumberSheet(formTable.Split('_')[1]);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataTable;
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
        public string LastNum()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ft"].ToString() == "" || jPost["part"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new ZumNet.BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetRegisterNumber(jPost["ft"].ToString().Split('_')[1], jPost["part"].ToString());
                    }
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        if (svcRt.ResultDataTable != null && svcRt.ResultDataTable.Rows.Count > 0) rt = svcRt.ResultDataTable.Rows[0][0].ToString();
                        else
                        {
                            rt = jPost["ft"].ToString() == "NUM_ME" ? "0001" : "A";
                        }

                        rt = "OK" + rt;
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SetNum()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ft"].ToString() == "" || jPost["part"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new ZumNet.BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetRegisterNumber(jPost["ft"].ToString().Split('_')[1], jPost["part"].ToString()
                            , Convert.ToInt32(jPost["urid"].ToString()), jPost["ur"].ToString(), Convert.ToInt32(jPost["deptid"].ToString()), jPost["dept"].ToString()
                            , jPost["model"].ToString(), jPost["item"].ToString(), jPost["etc"].ToString());
                    }
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK" + jPost["part"].ToString() + "번 채번되었습니다.";
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SetNumSheet()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ft"].ToString() == "" || jPost["nm"].ToString() == "" || jPost["val"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new ZumNet.BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetRegisterNumberSheet(jPost["ft"].ToString().Split('_')[1], jPost["nm"].ToString(), jPost["val"].ToString());
                    }
                    if (svcRt != null && svcRt.ResultCode == 0) rt = "OK";
                    else rt = svcRt.ResultMessage;
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
    }
}