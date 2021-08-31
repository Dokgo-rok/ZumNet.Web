using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.EA.Controllers
{
    public class MainController : Controller
    {
        // GET: EA/Main
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
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
            ViewBag.R["xfalias"] = "ea";

            //메뉴 권한체크 (objecttype='' 이면 폴더권한 체크 X)
            if (Session["Admin"].ToString() == "Y")
            {
                ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), 0, "", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            //담당 체크 및 문서함 정보
            rt = Bc.CtrlHandler.EAInit(this, true, "");
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult List(string Qi)
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
            ViewBag.R["xfalias"] = "ea";

            //메뉴 권한체크 (objecttype='' 이면 폴더권한 체크 X)
            if (Session["Admin"].ToString() == "Y")
            {
                ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), 0, "", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            //담당 체크 및 문서함 정보
            rt = Bc.CtrlHandler.EAInit(this, true, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ViewBag.R.lv["page"] = StringHelper.SafeString(ViewBag.R.lv["page"].ToString(), "1");
            ViewBag.R.lv["count"] = StringHelper.SafeString(Bc.CommonUtils.GetLvCookie("ea").ToString(), "20");
            
            ViewBag.R.lv["basesort"] = ViewBag.CurBox[5];
            ViewBag.R.lv["sort"] = ViewBag.CurBox[5];
            
            int iState = 0;
            string sLocation = ViewBag.CurBox[2].IndexOf('_') >= 0 ? "" : ViewBag.CurBox[2];

            //문서함 조회
            using (ZumNet.BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
            {
                if (sLocation == "te" || sLocation == "wd" || sLocation == "wt" || sLocation == "do" || sLocation == "cr")
                {
                    if (sLocation == "wt")
                    {
                        ViewBag.R.lv["search"] = Environment.MachineName;
                        ViewBag.R.lv["searchtext"] = Session["CompanyCode"].ToString();
                    }
                    if (sLocation == "cr") iState = 0;
                    else if (sLocation == "ug") iState = 1;
                    else if (sLocation == "uc") iState = 7;

                    svcRt = wkList.ViewListPerMenu(sLocation, "N", "", 0, Convert.ToInt32(ViewBag.PartID), iState, Convert.ToInt32(ViewBag.R.lv.page.Value)
                                            , Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), "DESC", "", "", "", "");
                }
                else
                {
                    svcRt = wkList.ViewProcessWorkList(sLocation, Convert.ToInt32(Session["DNID"]), ViewBag.R["xfalias"].ToString(), "", ViewBag.CurBox[3].ToString(), ViewBag.PartID
                                            , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["basesort"].ToString()
                                            , ViewBag.R.lv["sort"].ToString(), "DESC", "", "", "", "", Convert.ToInt32(Session["URID"]));
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataTable;
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
        public string List()
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

                    //담당 체크 및 문서함 정보
                    rt = Bc.CtrlHandler.EAInit(this, false, jPost["opnode"].ToString());
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    sPos = "300";
                    jPost["lv"]["basesort"] = ViewBag.CurBox[5];
                    if (jPost["lv"]["sort"].ToString() == "") jPost["lv"]["sort"] = jPost["lv"]["basesort"];

                    sPos = "400";
                    int iState = 0;
                    string sLocation = ViewBag.CurBox[2].IndexOf('_') >= 0 ? "" : ViewBag.CurBox[2];

                    //문서함 조회
                    using (ZumNet.BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                    {
                        if (sLocation == "te" || sLocation == "wd" || sLocation == "wt" || sLocation == "do" || sLocation == "cr")
                        {
                            sPos = "410";
                            if (sLocation == "wt")
                            {
                                ViewBag.R.lv["search"] = Environment.MachineName;
                                ViewBag.R.lv["searchtext"] = Session["CompanyCode"].ToString();
                            }
                            if (sLocation == "cr") iState = 0;
                            else if (sLocation == "ug") iState = 1;
                            else if (sLocation == "uc") iState = 7;

                            svcRt = wkList.ViewListPerMenu(sLocation, "N", "", 0, Convert.ToInt32(ViewBag.PartID), iState
                                        , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString()
                                        , jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString()
                                        , jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }
                        else
                        {
                            sPos = "420";
                            svcRt = wkList.ViewProcessWorkList(sLocation, Convert.ToInt32(Session["DNID"]), jPost["xfalias"].ToString()
                                                    , "", ViewBag.CurBox[3].ToString(), ViewBag.PartID
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["basesort"].ToString(), jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString()
                                                    , jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString()
                                                    , jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString(), Convert.ToInt32(Session["URID"]));
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";

                        ViewBag.BoardList = svcRt.ResultDataTable;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListCount", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Count()
        {
            string sPos = "";
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    string[] vPostData = CommonUtils.PostDataToString().Split(','); //xfalias,location,actrole,userid,userdeptid,admin

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    using (ZumNet.BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                    {
                        svcRt = wkList.GetWorkItemCount(Session["FlowSvcMode"].ToString(), Convert.ToInt32(Session["DNID"]), vPostData[0], "", vPostData[1], vPostData[2]
                                                    , vPostData[3], "", vPostData[4], "", vPostData[5], Environment.MachineName, Session["CompanyCode"].ToString(), "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        rt = "OK" + svcRt.ResultDataString;
                    }
                    else
                    {
                        //에러페이지
                        sPos = "400";
                        rt = svcRt.ResultMessage;
                    }
                }
                catch(Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }
            return rt;
        }

        
    }
}