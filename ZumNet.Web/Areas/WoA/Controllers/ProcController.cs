using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Xml;
using ZumNet.BSL.FlowBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Model;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class ProcController : ControllerWebBase
    {
        #region [ /WoA/Proc/Index ]

        // GET: WoA/Proc
        [SessionExpireFilter]
        [Authorize]
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
                ServiceResult resultForm = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    // 프로세스 조회
                    result = eApprovalBiz.SelectBFProcessDefinition(processID);
                    result.ResultDataTable.TableName = "dtDef";

                    // 프로세스를 사용하는 폼 정보 조회

                    resultForm = eApprovalBiz.SelectBFProcessFormList(processID);
                    resultForm.ResultDataTable.TableName = "dtForm";
                }

                DataSet dsProcess = new DataSet();
                dsProcess.Tables.Add(result.ResultDataTable.Copy());
                dsProcess.Tables.Add(resultForm.ResultDataTable.Copy());
                dsProcess.Tables.Add(CreateProcessActivities(processID));

                if (result.ResultCode == 0)
                {
                    ResultItemCount = result.ResultItemCount;
                    ResultData = JsonConvert.SerializeObject(dsProcess);

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
        /// 프로세스 정보 생성
        /// </summary>
        /// <param name="processID"></param>
        /// <returns></returns>
        private DataTable CreateProcessActivities(int processID)
        {
            DataTable dtProcess = new DataTable();

            GetProcessActivities(processID, "", 0, ref dtProcess);

            return dtProcess;
        }

        /// <summary>
        /// 프로세스 정보 조회 및 구성
        /// </summary>
        /// <param name="processID"></param>
        /// <param name="parentActivityID"></param>
        /// <param name="depth"></param>
        /// <param name="dtProcess"></param>
        private void GetProcessActivities(int processID, string parentActivityID, int depth, ref DataTable dtProcess)
        {
            ServiceResult result = new ServiceResult();

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                result = eApprovalBiz.SelectProcessActivities(processID, parentActivityID, "");

                int rowCount = result.ResultDataTable?.Rows?.Count ?? 0;

                if (rowCount > 0)
                {
                    if (dtProcess.Rows.Count == 0)
                    {
                        dtProcess = result.ResultDataTable.Clone();
                        dtProcess.TableName = "dtAct";
                    }

                    foreach (DataRow dr in result.ResultDataTable.Rows)
                    {
                        dtProcess.ImportRow(dr);

                        // 하위가 있는 경우
                        if (String.Compare(StringHelper.SafeString(dr["Inline"]), "Y", true) == 0)
                        {
                            GetProcessActivities(processID, StringHelper.SafeString(dr["activityID"]), depth + 1, ref dtProcess);
                        }
                    }
                }
            }
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

        /// <summary>
        /// 프로세스 정의 복사
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string CopyProcessDefinition()
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
                    eApprovalBiz.CopyBFProcessDefinition(processID, domainID, validFromDate, validToDate, processName, priority, description, inUse, creator, reserved1);
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

        #region [ /WoA/Proc/Export ]

        /// <summary>
        /// 프로세스 XML 내보내기
        /// </summary>
        /// <returns></returns>
        public ActionResult Export()
        {
            if (Request.QueryString.Count != 2)
            {
                return View();
            }

            int processID = StringHelper.SafeInt(Request.QueryString["processid"]);
            string processName = StringHelper.SafeString(Request.QueryString["processName"]);

            string xmlFileName = $"BFFlowDef_{processName}{DateTime.Now.ToString("yyyyMMdd")}.xml";

            ServiceResult result = new ServiceResult();

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                result = eApprovalBiz.SelectBFProcessDefinitionForExport(processID);
            }

            if (result.ResultCode >= 0)
            {
                string xmlInfo = StringHelper.SafeString(result.ResultDataTable.Rows[0][0]);

                if (String.IsNullOrWhiteSpace(xmlInfo))
                {
                    return View();
                }

                xmlFileName = HttpUtility.UrlEncode(xmlFileName, new UTF8Encoding()).Replace("+", "%20");

                Response.Clear();
                Response.Charset = "utf-8";
                Response.Buffer = true;

                Response.ContentType = "application/unknown";
                Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;
                Response.AddHeader("content-disposition", "attachment;filename=" + xmlFileName + "");
                Response.Write("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
                Response.Write(xmlInfo);
                Response.End();
            }

            return View();
        }

        #endregion

        #region [ /WoA/Proc/Import ]

        // GET: WoA/Proc
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Import()
        {
            return View();
        }

        /// <summary>
        /// 프로세스 XML 가져오기
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        [HttpPost]
        //[ValidateAntiForgeryToken]
        public string UploadFile(HttpPostedFileBase file)
        {
            if (file == null)
            {
                file = Request.Files[0];
            }

            if (file != null && file.ContentLength > 0)
            {
                string steptext = "";

                try
                {
                    if (!file.FileName.Contains(".xml"))
                    {
                        return "FAIL:XML 파일을 업로드해 주세요.";
                    }

                    steptext = "FAIL:파일 읽기에 실패했습니다.";

                    StreamReader sr = new StreamReader(file.InputStream, Encoding.GetEncoding("utf-8"));

                    string strxml = sr.ReadToEnd();

                    steptext = "FAIL:올바른 프로세스 정의 파일이 아닙니다.";

                    XmlDocument xdoc = new XmlDocument();
                    xdoc.LoadXml(strxml);

                    XmlNode xdef = xdoc.DocumentElement.SelectSingleNode("/bfflow_def/definition");
                    XmlNode xact = xdoc.DocumentElement.SelectSingleNode("/bfflow_def/activities");
                    XmlNode xatt = xdoc.DocumentElement.SelectSingleNode("/bfflow_def/attributes");
                    XmlNode xpart = xdoc.DocumentElement.SelectSingleNode("/bfflow_def/participants");

                    steptext = "";

                    ServiceResult result = new ServiceResult();

                    using (EApprovalBiz eapprovalBiz = new EApprovalBiz())
                    {
                        result = eapprovalBiz.CreateBFProcessWithImport("Y", StringHelper.SafeInt(xdef.Attributes["defid"].Value), StringHelper.SafeInt(xdef.Attributes["dnid"].Value), xdef.SelectSingleNode("nm").InnerText, xdef.OuterXml, xact.OuterXml, xatt.OuterXml, xpart.OuterXml);
                    }

                    if (result.ResultCode == 0)
                    {
                        return "OK:정상적으로 처리되었습니다.";
                    }
                    else
                    {
                        return $"FAIL:{result.ResultMessage}";
                    }
                }
                catch (Exception ex)
                {
                    if (!string.IsNullOrWhiteSpace(steptext))
                    {
                        return steptext;
                    }
                    else
                    {
                        return $"FAIL:{ex.Message.ToString()}";
                    }
                }
            }

            return CreateJsonData();
        }

        #endregion

        #region [ /WoA/Proc/Mgr ]

        // GET: WoA/Proc
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Mgr()
        {
            string companyCode = StringHelper.SafeString(WebConfigurationManager.AppSettings["CompanyCode"]);
            string preAppMode = "";
            string svcMode = "";
            int interval = 0;

            using (EApprovalBiz eapprovalBiz = new EApprovalBiz())
            {
                eapprovalBiz.ConnectionString = DbConnect.GetString(DbConnect.INITIAL_CATALOG.INIT_CAT_SERVICE);

                ServiceResult resultCompnay = eapprovalBiz.SelectBFServiceCompanyDetail(companyCode);

                if (resultCompnay.ResultCode == 0)
                {
                    int rowCount = resultCompnay?.ResultDataTable?.Rows?.Count ?? 0;

                    if (rowCount > 0)
                    {
                        preAppMode = StringHelper.SafeString(resultCompnay.ResultDataTable.Rows[0]["BFFlowPreAppMode"]);
                        svcMode = StringHelper.SafeString(resultCompnay.ResultDataTable.Rows[0]["BFFlowSvcMode"]);
                        interval = StringHelper.SafeInt(resultCompnay.ResultDataTable.Rows[0]["BFFlowSvcInterval"]);
                    }
                }
            }

            if (String.Compare(preAppMode, "S", true) == 0 || String.Compare(svcMode, "S", true) == 0)
            {
                using (EApprovalBiz eapprovalBiz = new EApprovalBiz())
                {
                    ServiceResult resultMember = eapprovalBiz.SelectBFServiceMemberDetail();

                    ViewData["mgrMemberJson"] = JsonConvert.SerializeObject(resultMember.ResultDataTable);
                }   
            }

            ViewData["preAppMode"] = preAppMode;
            ViewData["svcMode"] = svcMode;
            ViewData["interval"] = interval;

            return View();
        }

        /// <summary>
        /// 서비스 모드 변경
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string ChangeServiceMode()
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

                int userID = StringHelper.SafeInt(jPost["userID"]);
                string preAppMode = StringHelper.SafeString(jPost["preAppMode"]);
                string svcMode = StringHelper.SafeString(jPost["svcMode"]);
                int interval = StringHelper.SafeInt(jPost["interval"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    eApprovalBiz.ChangeUserServiceMode(userID, svcMode, interval, preAppMode);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = result.ResultMessage;
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

        #region [ /WoA/Proc/Process ]

        // GET: WoA/Proc
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Process()
        {
            return View();
        }

        /// <summary>
        /// 서비스 모드 처리 목록 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SearchServiceModeProcessList()
        {
            if (Request.IsAjaxRequest())
            {
                string mode = StringHelper.SafeString(Request.Form["mode"]);
                string admin = "";
                string formID = "";
                int defId = 0;
                int viewer = 0;
                int state = 0;
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchCol = Session["CompanyCode"].ToString();
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStart = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEnd = StringHelper.SafeString(Request.Form["searchEndDate"]);

                searchText = (String.Compare(searchText, "ALL", true) == 0) ? "" : " AND a.Status = " + searchText;

                ServiceResult result = new ServiceResult();

                using (WorkList workList = new WorkList())
                {
                    result = workList.ViewListPerMenu(mode, admin, formID, defId, viewer, state, pageIndex, pageCount, sortColumn, sortType, searchCol, searchText, searchStart, searchEnd);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMessage"]);
                    ResultItemFilteredCount = ResultItemCount;

                    if (result.ResultItemCount > 0)
                    {
                        result.ResultDataTable.Columns.Add("DisplaySignStatus", typeof(string));

                        foreach (DataRow dr in result.ResultDataTable.Rows)
                        {
                            dr["DisplaySignStatus"] = ProcessStateChart.ParsingSignStatus(StringHelper.SafeInt(dr["SignStatus"]));
                        }
                    }

                    ResultPageIndex = pageIndex;
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
        /// 상태 변경
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string ChangeServiceState()
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

                string entityKind = StringHelper.SafeString(jPost["entityKind"]);
                string targetID = StringHelper.SafeString(jPost["targetID"]);
                int stateValue = StringHelper.SafeInt(jPost["stateValue"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    eApprovalBiz.ChangeBFServiceState(entityKind, targetID, stateValue);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = result.ResultMessage;
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

        #region [ /WoA/Proc/Record ]

        // GET: WoA/Proc
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Record()
        {
            return View();
        }

        #endregion
    }
}