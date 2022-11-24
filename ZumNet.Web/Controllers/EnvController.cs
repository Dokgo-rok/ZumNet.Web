using System;
using System.Collections.Generic;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Util;
using ZumNet.BSL.ServiceBiz;
namespace ZumNet.Web.Controllers
{
    public class EnvController : Controller
    {
        /// <summary>
        /// 개인정보 환경설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SavePersonInfo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["UserID"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (OfficePortalBiz opBiz = new OfficePortalBiz())
                    {
                        svcRt = opBiz.SetPersonInfo(jPost);
                    }

                    if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                    else rt = "OK";
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