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

            return View();
        }
    }
}