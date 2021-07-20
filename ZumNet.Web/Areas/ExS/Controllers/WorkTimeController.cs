using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class WorkTimeController : Controller
    {
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        /// <summary>
        /// 근무상태 이벤트 설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string StatusEvent()
        {
            string strView = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0 || jPost["ss"].ToString() == "")
                {
                    return "필수값 누락!";
                }

                string sUA = CommonUtils.UserAgent(Request.ServerVariables["HTTP_USER_AGENT"]);

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                
                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    svcRt = wtBiz.CreateWorkTimeStatus(Convert.ToInt32(Session["URID"]), DateTime.Now.ToString("yyyy-MM-dd")
                                                    , jPost["ss"].ToString(), Request.ServerVariables["REMOTE_HOST"], sUA);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    strView = "OK";
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