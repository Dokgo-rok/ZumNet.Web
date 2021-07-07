using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class LinkSiteController : Controller
    {
        // GET: LinkSite
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
            int iOpenNode = 0;
            if (ViewBag.R.opnode.Value != "")
            {
                if (ViewBag.R.opnode.Value.IndexOf('.') > 0)
                {
                    string[] v = ViewBag.R.opnode.Value.Split('.');
                    iOpenNode = Convert.ToInt32(v[v.Length - 1]);
                }
                else iOpenNode = Convert.ToInt32(ViewBag.R.opnode.Value);
            }

            //using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            //{
            //    svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iOpenNode, Convert.ToInt32(Session["URID"]), Session["Admin"].ToString(), "", 1, 20, "SeqID", "DESC", "", "", "", "");
            //}

            //if (svcRt != null && svcRt.ResultCode == 0)
            //{
            //    ViewBag.BoardList = svcRt.ResultDataRowCollection;
            //    ViewBag.BoardTotal = svcRt.ResultItemCount;
            //}
            //else
            //{
            //    rt = svcRt.ResultMessage;
            //    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //}

            return View();
        }
    }
}