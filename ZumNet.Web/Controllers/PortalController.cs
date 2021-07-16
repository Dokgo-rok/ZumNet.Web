using System;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class PortalController : Controller
    {
        /// <summary>
        /// 메인 포탈
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            //ZumNet.Framework.Core.ServiceResult svcRt = null;

            //using (ZumNet.BSL.ServiceBiz.CommonBiz com = new ZumNet.BSL.ServiceBiz.CommonBiz())
            //{
            //    //svcRt = com.GetMenuInformation(1, 0, 101374, "N", "0", "KO");
            //    svcRt = com.GetMenuTop(1, 101374, "N", "KO");
            //}

            //if (svcRt != null && svcRt.ResultCode == 0)
            //{
            //    ViewBag.MainMenu = svcRt.ResultDataTable;
            //    ViewBag.LindSite = svcRt.ResultDataSet;
            //    ViewBag.ShoutLnk = svcRt.ResultDataDetail["ShortLink"];
            //    ViewBag.DeptList = svcRt.ResultDataDetail["DeptList"];
            //}
            //else
            //{
            //    //에러페이지
            //}


            return View();
        }

        /// <summary>
        /// 출근 체크
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult ClockIn(ZumNet.Web.Models.WorkTimeViewModels workTime)
        {
            return View(workTime);
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult SSOerp()
        {
            return View();
        }

        /// <summary>
        /// 언어 설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Locale()
        {
            string strView = "";
            try
            {
                if (Request.IsAjaxRequest())
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if ((jPost == null || jPost.Count == 0) && jPost["locale"].ToString() == "")
                    {
                        return "필수값 누락!";
                    }

                    AuthManager.SetLocaleCookie(jPost["locale"].ToString());

                    strView = "OK";
                }
            }
            catch(Exception ex)
            {
                strView = ex.Message;
            }
            return strView;
        }
    }
}