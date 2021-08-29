using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class DashboardController : ControllerWebBase
    {
        #region [ WoA/Dashboard/Index ]

        // GET: WoA/Dashboard
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            return View();
        }

        #endregion

        #region [ WoA/Dashboard/Code ]

        // GET: WoA/Dashboard/Code
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Code()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchCodeInfo()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    ResultCode = "FAIL";
                    ResultMessage = "필수값 누락";

                    return CreateJsonData();
                }

                string actionKind = StringHelper.SafeString(jPost["actionKind"].ToString());
                int containerID = StringHelper.SafeInt(jPost["containerID"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetContainer(actionKind, containerID);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = result.ResultItemCount;
                    ResultData = JsonConvert.SerializeObject(result.ResultDataTable);

                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = "SP 조회 오류";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        /// <summary>
        /// 코드 제어 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string HandleCode()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    ResultCode = "FAIL";
                    ResultMessage = "필수값 누락";

                    return CreateJsonData();
                }

                string actionKind = StringHelper.SafeString(jPost["actionKind"].ToString());
                int containerID = StringHelper.SafeInt(jPost["containerID"].ToString());
                int memberOf = StringHelper.SafeInt(jPost["memberOf"].ToString());
                string displayName = StringHelper.SafeString(jPost["displayName"].ToString());
                int sortKey = StringHelper.SafeInt(jPost["sortKey"].ToString());
                string command = StringHelper.SafeString(jPost["command"].ToString());
                string description = StringHelper.SafeString(jPost["description"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.HandleBaseContainer(actionKind, containerID, memberOf, displayName, sortKey, command, description);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = "코드 생성에 실패하였습니다.";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        #endregion

        #region [ WoA/Dashboard/CodeView ]

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <param name="title"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult CodeView(string code, string title, string description)
        {
            if (String.IsNullOrWhiteSpace(code) || code.Split('.').Length != 2)
            {
                return Redirect("/Woa/DashBoard/Code");
            }

            string key1 = code.Split('.')[0];
            string key2 = code.Split('.')[1];

            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                result = commonBiz.SelectCodeDescription(key1, key2, "");
            }

            ViewData["key1"] = key1;
            ViewData["key2"] = key2;
            ViewData["title"] = title;
            ViewData["description"] = description;

            return View(result.ResultDataTable);
        }

        /// <summary>
        /// 코드 Item 제어 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string HandleCodeItem()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    ResultCode = "FAIL";
                    ResultMessage = "필수값 누락";

                    return CreateJsonData();
                }

                string mode = StringHelper.SafeString(jPost["mode"].ToString());
                string key1 = StringHelper.SafeString(jPost["key1"].ToString());
                string key2 = StringHelper.SafeString(jPost["key2"].ToString());
                string key3 = StringHelper.SafeString(jPost["key3"].ToString());
                string item1 = StringHelper.SafeString(jPost["item1"].ToString());
                string item2 = StringHelper.SafeString(jPost["item2"].ToString());
                string item3 = StringHelper.SafeString(jPost["item3"].ToString());
                string item4 = StringHelper.SafeString(jPost["item4"].ToString());
                string item5 = StringHelper.SafeString(jPost["item5"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.HandleCodeDescription(mode, key1, key2, key3, item1, item2, item3, item4, item5);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = "코드 생성에 실패하였습니다.";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        #endregion

        #region [ WoA/Dashboard/Policy ]

        // GET: WoA/Dashboard/Policy
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Policy()
        {
            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                result = commonBiz.GetPasswordPolicy();
            }

            if (result.ResultCode == 0 && result.ResultDataTable?.Rows?.Count > 0)
            {
                ViewData["iscomplex"] = StringHelper.SafeString(result.ResultDataTable.Rows[0]["iscomplex"]).ToUpper();
                ViewData["pwlenth"] = StringHelper.SafeString(result.ResultDataTable.Rows[0]["pwlenth"]);
                ViewData["pwinterval"] = StringHelper.SafeString(result.ResultDataTable.Rows[0]["pwinterval"]);
            }

            return View();
        }

        /// <summary>
        /// 정책 설정
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string HandlePolicy()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    ResultCode = "FAIL";
                    ResultMessage = "필수값 누락";

                    return CreateJsonData();
                }

                // ServiceResult SetPasswordPolicy(string changeitem, string changevalue)

                string changeitem = StringHelper.SafeString(jPost["changeitem"].ToString());
                string changevalue = StringHelper.SafeString(jPost["changevalue"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.SetPasswordPolicy(changeitem, changevalue);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = "코드 생성에 실패하였습니다.";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        #endregion

        #region [ WoA/Dashboard/Webpart ]

        // GET: WoA/Dashboard
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Webpart()
        {
            return View();
        }

        #endregion
    }
}