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
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);

            //권한체크
            if (Session["Admin"].ToString() == "Y")
            {
                ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            rt = "권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }
    }
}