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
    public class MCController : Controller
    {
        // GET: ExS/MC
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
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

            int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);

            //권한 가져오기
            rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "W")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            ViewBag.Mode = ViewBag.R.mode.ToString();

            return View();
        }
    }
}