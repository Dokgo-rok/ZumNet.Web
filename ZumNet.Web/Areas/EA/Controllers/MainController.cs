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

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
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

            using (ZumNet.BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
            {
                svcRt = wkList.GetMenuConfig(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DeptID"]));
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.FormCharger = svcRt.ResultDataDetail["FormCharger"];
                ViewBag.RcvManager = svcRt.ResultDataDetail["RcvManager"];
                ViewBag.SharedFolder = svcRt.ResultDataRowCollection;
            }
            else
            {
                //에러페이지
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
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