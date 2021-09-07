using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class ProcController : ControllerWebBase
    {
        #region [ /WoA/Proc/Index ]

        // GET: WoA/Proc
        public ActionResult Index()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            ServiceResult result = new ServiceResult();

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 프로세스 조회
                result = eApprovalBiz.SelectProcessListByCondition(domainID, 0, "Y");
            }

            return View(result.ResultDataTable);
        }

        /// <summary>
        /// 프로세스 목록 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectProcessList()
        {
            if (Request.IsAjaxRequest())
            {
                int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    // 프로세스 조회
                    result = eApprovalBiz.SelectProcessListByCondition(domainID, 0, "Y");
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
        /// 프로세스 상세 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectProcessDefinition()
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

                int processID = StringHelper.SafeInt(jPost["processID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    // 프로세스 조회
                    result = eApprovalBiz.SelectBFProcessDefinition(processID);
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
        /// 프로세스 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string HandleProcessDefinition()
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

                int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
                int processID = StringHelper.SafeInt(jPost["processID"]);
                string validFromDate = StringHelper.SafeString(jPost["validFromDate"]);
                string validToDate = StringHelper.SafeString(jPost["validToDate"]);
                string processName = StringHelper.SafeString(jPost["processName"]);
                int priority = StringHelper.SafeInt(jPost["priority"]);
                string description = StringHelper.SafeString(jPost["description"]);
                string inUse = StringHelper.SafeString(jPost["inUse"]);
                string creator = StringHelper.SafeString(jPost["creator"]);
                string reserved1 = StringHelper.SafeString(jPost["reserved1"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    if (processID == 0)
                    {
                        result = eApprovalBiz.CreateBFProcessDefinition(domainID, validFromDate, validToDate, processName, priority, description, inUse, creator, reserved1);
                    }
                    else
                    {
                        result = eApprovalBiz.UpdateBFProcessDefinition(processID, validFromDate, validToDate, processName, priority, description, inUse, creator, reserved1);
                    }
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
    }
}