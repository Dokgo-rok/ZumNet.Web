using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class BoardController : Controller
    {
        // GET: Board
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

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iOpenNode, Convert.ToInt32(Session["URID"]), Session["Admin"].ToString(), "", 1, 20, "SeqID", "DESC", "", "", "", "");
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataRowCollection;
                ViewBag.BoardTotal = svcRt.ResultItemCount;
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
        public string Index(string Qi)
        {
            string strView = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                {
                    svcRt = bd.GetMessgaeListInfoAddTopLine(1, Convert.ToInt32(jPost["ct"]), Convert.ToInt32(jPost["tgt"])
                                                , Convert.ToInt32(Session["URID"]), Session["Admin"].ToString(), ""
                                                , Convert.ToInt32(jPost["page"]), Convert.ToInt32(jPost["count"])
                                                , "SeqID", "DESC", "", "", "", "");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.BoardList = svcRt.ResultDataRowCollection;
                    ViewBag.BoardTotal = svcRt.ResultItemCount;

                    strView = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListView", ViewBag);
                }
                else
                {
                    //에러페이지
                    strView = svcRt.ResultMessage;
                }
            }
            return strView;
        }
    }
}