using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Flow;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.App_Code;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class AppController : ControllerWebBase
    {
        #region [ /Woa/App/Index ]

        // GET: WoA/App
        public ActionResult Index()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 양식 분류 조회
                ServiceResult resultClass = eApprovalBiz.SelectEAFormClass(domainID);

                if (resultClass.ResultCode == 0 && resultClass.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["formclass"] = JsonConvert.SerializeObject(resultClass.ResultDataTable);
                }

                // 양식 문서 리스트 조회
                ServiceResult resultList = eApprovalBiz.SelectEAFormList(domainID);

                if (resultList.ResultCode == 0)
                {
                    if (resultList.ResultCode == 0 && resultList.ResultDataTable?.Rows?.Count > 0)
                    {
                        ViewData["formlist"] = JsonConvert.SerializeObject(resultList.ResultDataTable);
                    }
                }
            }

            return View();
        }

        /// <summary>
        /// 결재 문서 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SearchEADocumentList()
        {
            if (Request.IsAjaxRequest())
            {
                string mode = StringHelper.SafeString(Request.Form["mode"]);
                string admin = StringHelper.SafeString(Request.Form["admin"]);
                string formID = StringHelper.SafeString(Request.Form["formId"]);

                if (!String.IsNullOrWhiteSpace(formID))
                {
                    mode = "pf";
                }

                int defId = StringHelper.SafeInt(Request.Form["defId"]);
                int viewer = StringHelper.SafeInt(Request.Form["viewer"]);
                int state = StringHelper.SafeInt(Request.Form["state"]);
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchCol = StringHelper.SafeString(Request.Form["searchCol"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStart = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEnd = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
                }

                if (String.IsNullOrWhiteSpace(searchCol) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (WorkList workList = new WorkList())
                {
                    result = workList.ViewListPerMenu(mode, admin, formID, defId, viewer, state, pageIndex, pageCount, sortColumn, sortType, searchCol, searchText, searchStart, searchEnd);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMessage"]);
                    ResultItemFilteredCount = ResultItemCount;
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
        /// 결재 문서의 기본 정보 정보
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectEADocumentTotalData()
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

                int dnID = StringHelper.SafeInt(jPost["domainID"].ToString());
                int messageID = StringHelper.SafeInt(jPost["messageID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.SelectEADocumentTotalData(dnID, messageID);
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
        /// 결재선 정보 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectEAApprovalLineInfo()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "ERROR##필수값 누락";
                }

                int oID = StringHelper.SafeInt(jPost["oid"]);
                string itemKey = StringHelper.SafeString(jPost["itemKey"]);
                string itemSubKey = StringHelper.SafeString(jPost["itemSubKey"]);

                ServiceResult result = new ServiceResult();

                using (WorkList workListBiz = new WorkList())
                {
                    result = workListBiz.SelectBFWorkItemOID(oID);
                }

                if (result.ResultCode == 0)
                {
                    DataTable dtActRole = new DataTable();
                    DataTable dtBizRole = new DataTable();

                    ServiceResult resultCode = new ServiceResult();

                    using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                    {
                        resultCode = eApprovalBiz.SelectBFCodeRole(itemKey, itemSubKey);

                        if (resultCode.ResultCode == 0 && resultCode?.ResultDataTable?.Rows?.Count > 0)
                        {
                            if (resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "bizrole", true) == 0).Count() > 0)
                            {
                                dtBizRole = resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "bizrole", true) == 0).CopyToDataTable();
                            }

                            if (resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "actrole", true) == 0).Count() > 0)
                            {
                                dtActRole = resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "actrole", true) == 0).CopyToDataTable();
                            }
                        }
                    }

                    // 결재 정보를 넘겨 HTML을 받아온다.
                    ApprovalLine appLine = new ApprovalLine(result.ResultDataTable);

                    return $"OK##{appLine.GetApprovalLineHtml(dtBizRole, dtActRole)}";
                }
                else
                {
                    return "ERROR##HTML 구성 오류";
                }
            }
            else
            {
                return "ERROR##AJAX에서 호출되지 않음";
            }
        }

        /// <summary>
        /// WI 정보 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectEAWorkItemInfo()
        {
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "ERROR##필수값 누락";
                }

                int oID = StringHelper.SafeInt(jPost["oid"]);
                string itemKey = StringHelper.SafeString(jPost["itemKey"]);
                string itemSubKey = StringHelper.SafeString(jPost["itemSubKey"]);

                ServiceResult result = new ServiceResult();

                using (WorkList workListBiz = new WorkList())
                {
                    result = workListBiz.SelectBFWorkItemOID(oID);
                }

                if (result.ResultCode == 0)
                {
                    DataTable dtActRole = new DataTable();
                    DataTable dtBizRole = new DataTable();

                    ServiceResult resultCode = new ServiceResult();

                    using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                    {
                        resultCode = eApprovalBiz.SelectBFCodeRole(itemKey, itemSubKey);

                        if (resultCode.ResultCode == 0 && resultCode?.ResultDataTable?.Rows?.Count > 0)
                        {
                            if (resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "bizrole", true) == 0).Count() > 0)
                            {
                                dtBizRole = resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "bizrole", true) == 0).CopyToDataTable();
                            }

                            if (resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "actrole", true) == 0).Count() > 0)
                            {
                                dtActRole = resultCode.ResultDataTable.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["ItemSubKey"]), "actrole", true) == 0).CopyToDataTable();
                            }
                        }
                    }

                    // 결재 정보를 넘겨 HTML을 받아온다.
                    ApprovalLine appLine = new ApprovalLine(result.ResultDataTable);

                    return $"OK##{appLine.GetWorkItemHtml(dtBizRole, dtActRole)}";
                }
                else
                {
                    return "ERROR##HTML 구성 오류";
                }
            }
            else
            {
                return "ERROR##AJAX에서 호출되지 않음";
            }
        }

        /// <summary>
        /// 결재 문서 삭제
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string DeleteBFEAData()
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

                string command = StringHelper.SafeString(jPost["command"]);
                int messageID = StringHelper.SafeInt(jPost["messageID"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.DeleteBFEAData(command, messageID);
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

        #region [ /Woa/App/Class ]

        // GET: WoA/App/Class
        public ActionResult Class()
        {
            return View();
        }

        /// <summary>
        /// 결재 양식 분류 정보 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SearchEAFormClass()
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

                int domainID = StringHelper.SafeInt(jPost["dnID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.SelectEAFormClass(domainID);
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
        /// 결재 양식 분류 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string HandleEAFormClass()
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

                string command = StringHelper.SafeString(jPost["command"].ToString());
                int classid = StringHelper.SafeInt(jPost["classid"].ToString());
                int domainid = StringHelper.SafeInt(jPost["domainid"].ToString());
                string formname = StringHelper.SafeString(jPost["formname"].ToString());
                int formseqno = StringHelper.SafeInt(jPost["formseqno"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormClass(command, classid, domainid, formname, formseqno);
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

        #region [ /Woa/App/Mgr ]

        public ActionResult Mgr()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 양식 분류 조회
                ServiceResult resultClass = eApprovalBiz.SelectEAFormClass(domainID);

                if (resultClass.ResultCode == 0 && resultClass.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["formclass"] = JsonConvert.SerializeObject(resultClass.ResultDataTable);
                }

                // 양식 문서 리스트 조회
                ServiceResult resultList = eApprovalBiz.SelectEAFormList(domainID);

                if (resultList.ResultCode == 0)
                {
                    if (resultList.ResultCode == 0 && resultList.ResultDataTable?.Rows?.Count > 0)
                    {
                        ViewData["formlist"] = JsonConvert.SerializeObject(resultList.ResultDataTable);
                    }
                }

                // 프로세스 조회
                ServiceResult resultProcess = eApprovalBiz.SelectProcessListByCondition(domainID, 0, "Y");

                if (resultProcess.ResultCode == 0 && resultProcess.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["formprocess"] = JsonConvert.SerializeObject(resultProcess.ResultDataTable);
                }
            }

            // 이미 정의되어 있는 메인 필드 처리
            Dictionary<string, string> dicDefMainField = new Dictionary<string, string>(12);
            dicDefMainField.Add("DocName", "문서명");
            dicDefMainField.Add("DocNumber", "문서번호");
            dicDefMainField.Add("DocLevel", "문서등급");
            dicDefMainField.Add("KeepYear", "보존년한");
            dicDefMainField.Add("Subject", "제목");
            dicDefMainField.Add("Creator", "작성자");
            dicDefMainField.Add("PublishDate1", "등록일(-)");
            dicDefMainField.Add("PublishDate2", "등록일(/)");
            dicDefMainField.Add("PublishDate3", "등록일(.)");
            dicDefMainField.Add("CreatorDept", "작성부서");
            dicDefMainField.Add("ExternalKey1", "외부키1");
            dicDefMainField.Add("ExternalKey2", "외부키2");

            ViewData["definemainfield"] = JsonConvert.SerializeObject(dicDefMainField);

            return View();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string SelectBFEAFormData()
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
                string formID = StringHelper.SafeString(jPost["formID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.SelectBFEAFormData(domainID, formID);
                }

                if (result.ResultCode == 0)
                {
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
        /// 양식 폼 기본 정보 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string BFHandleEAFormBasicManagement()
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

                string command = StringHelper.SafeString(jPost["command"]);
                command = (String.Compare(command, "I", true) == 0) ? "create" : "modify";
                int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
                string formID = StringHelper.SafeString(jPost["formID"]);
                formID = (String.Compare(command, "create", true) == 0) ? Guid.NewGuid().ToString().ToUpper().Replace("-", "") : formID;
                int classID = StringHelper.SafeInt(jPost["classID"]);
                int processID = StringHelper.SafeInt(jPost["processID"]);
                string docName = StringHelper.SafeString(jPost["docName"]);
                string description = StringHelper.SafeString(jPost["description"]);
                string selectable = StringHelper.SafeString(jPost["selectable"]);
                string xslName = StringHelper.SafeString(jPost["xslName"]);
                string cssName = StringHelper.SafeString(jPost["cssName"]);
                string jsName = StringHelper.SafeString(jPost["jsName"]);
                string usage = StringHelper.SafeString(jPost["usage"]);
                string mainTable = StringHelper.SafeString(jPost["mainTable"]);
                mainTable = (mainTable.IndexOf("FORM_") < 0) ? "FORM_" + mainTable : mainTable;

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormBasicManagement(command, domainID, formID, classID, processID, docName, description, selectable, xslName, cssName, jsName, usage, mainTable);
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
        /// 양식 사용 종류 변경 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string BFHandleEAFormUsageManagement()
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

                string command = StringHelper.SafeString(jPost["command"]);
                string formID = StringHelper.SafeString(jPost["formID"]);
                string usage = StringHelper.SafeString(jPost["usage"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormTableManagement(command, formID, "", 0, usage);
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
        /// 양식 메인 테이블 정보 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string BFHandleEAFormMainTableManagement()
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

                string command = StringHelper.SafeString(jPost["command"]);
                string formID = StringHelper.SafeString(jPost["formID"]);
                string tableDef = StringHelper.SafeString(jPost["tableDef"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormTableManagement(command, formID, tableDef, 0, "");
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
        /// 양식 하위 테이블 정보 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string BFHandleEAFormSubTableManagement()
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

                string command = StringHelper.SafeString(jPost["command"]);
                string formID = StringHelper.SafeString(jPost["formID"]);
                string tableDef = StringHelper.SafeString(jPost["tableDef"]);
                int tableCount = StringHelper.SafeInt(jPost["tableCount"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormTableManagement(command, formID, tableDef, tableCount, "");
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
        /// 양식 기타 정보 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string BFHandleEAFormETCManagement()
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

                string formID = StringHelper.SafeString(jPost["formID"]);
                string webEditor = StringHelper.SafeString(jPost["webEditor"]);
                string htmlFile = StringHelper.SafeString(jPost["htmlFile"]);
                string processNameString = StringHelper.SafeString(jPost["processNameString"]);
                string validation = StringHelper.SafeString(jPost["validation"]);

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.HandleEAFormEtcManagement(formID, webEditor, htmlFile, processNameString, validation);
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

        #region [ /Woa/App/Charge ]

        public ActionResult Charge()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 양식 분류 조회
                ServiceResult result = eApprovalBiz.SelectEAFormSelect(domainID, 0, "Y");

                if (result.ResultCode == 0 && result.ResultDataSet?.Tables?.Count > 0)
                {
                    ViewData["formclass"] = result.ResultDataSet.Tables[0];

                    DataTable dtList = result.ResultDataSet.Tables[1];
                    DataTable dtChargeDeptList = result.ResultDataSet.Tables[2];
                    DataTable dtChargeMemberList = result.ResultDataSet.Tables[3];

                    if (dtList?.Rows?.Count > 0)
                    {
                        dtList.Columns.Add("ChargeDeptDisplayName", typeof(string));
                        dtList.Columns.Add("ChargeMemberDisplayName", typeof(string));
                        dtList.Columns.Add("ChargeDept", typeof(string));
                        dtList.Columns.Add("ChargeMember", typeof(string));

                        foreach (DataRow dr in dtList.Rows)
                        {
                            string chargeDeptDisplayList = "";
                            string chargeMemberDisplayList = "";
                            string chargeDeptList = "";
                            string chargeMemberList = "";

                            if (dtChargeDeptList?.Rows?.Count > 0)
                            {
                                if (dtChargeDeptList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).Count() > 0)
                                {
                                    chargeDeptDisplayList = String.Join(", ", dtChargeDeptList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => StringHelper.SafeString(x["DisplayName"])));
                                    chargeDeptList = String.Join(",", dtChargeDeptList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => StringHelper.SafeString(x["ChargeID"])));
                                }
                            }

                            if (dtChargeMemberList?.Rows?.Count > 0)
                            {
                                if (dtChargeMemberList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).Count() > 0)
                                {
                                    chargeMemberDisplayList = String.Join(", ", dtChargeMemberList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => $"({StringHelper.SafeString(x["GroupName"])}) {StringHelper.SafeString(x["Grade1"])} {StringHelper.SafeString(x["DisplayName"])}"));
                                    chargeMemberList = String.Join(",", dtChargeMemberList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => StringHelper.SafeString(x["ChargeID"])));
                                }
                            }

                            dr["ChargeDeptDisplayName"] = chargeDeptDisplayList;
                            dr["ChargeMemberDisplayName"] = chargeMemberDisplayList;
                            dr["ChargeDept"] = chargeDeptList;
                            dr["ChargeMember"] = chargeMemberList;
                        }
                    }

                    ViewData["formlist"] = dtList;
                }
            }

            using (OfficePortalBiz portalBiz = new OfficePortalBiz())
            {
                ServiceResult resultDept = portalBiz.SearchDomainGroups(domainID.ToString(), "", "D", "", "", "", "Y");

                if (resultDept.ResultCode == 0 && resultDept.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["deptlist"] = JsonConvert.SerializeObject(resultDept.ResultDataTable);
                }
            }

            using (CommonBiz commonBiz = new CommonBiz())
            {
                ServiceResult resultMember = commonBiz.SearchDomainUsers(domainID.ToString(), "", "D", 0, 0, "DisplayName", "ASC", "", "Y");

                if (resultMember.ResultCode == 0 && resultMember.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["memberlist"] = JsonConvert.SerializeObject(resultMember.ResultDataTable);
                }
            }

            return View();
        }

        /// <summary>
        /// 담당자/담당부서 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateChargeInfo()
        {
            if (Request.IsAjaxRequest())
            {
                if (String.IsNullOrWhiteSpace(Request.Form[0]))
                {
                    ResultCode = "FAIL";
                    ResultMessage = "필수값 누락";

                    return CreateJsonData();
                }

                JObject jObj = JObject.Parse(Request.Form[0]);

                string formID = StringHelper.SafeString(jObj["formID"].ToString());
                string chargeJson = StringHelper.SafeString(jObj["chargeJson"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.UpdateEAFormChargeJson(formID, chargeJson);
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

        #region [ /Woa/App/Option ]

        public ActionResult Option()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 양식 분류 조회
                ServiceResult resultClass = eApprovalBiz.SelectEAFormClass(domainID);

                if (resultClass.ResultCode == 0 && resultClass.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["formclass"] = resultClass.ResultDataTable;
                }

                // 양식 문서 리스트 조회
                ServiceResult resultList = eApprovalBiz.SelectEAFormList(domainID);

                if (resultList.ResultCode == 0)
                {
                    if (resultList.ResultCode == 0 && resultList.ResultDataTable?.Rows?.Count > 0)
                    {
                        DataTable dtList = resultList.ResultDataTable;

                        dtList.Columns.Add("DisplayUsage", typeof(string));             // 사용구분
                        dtList.Columns.Add("DisplayPageSet", typeof(string));           // 양식형태
                        dtList.Columns.Add("DisplayAddInfo1", typeof(string));          // 양식약식명
                        dtList.Columns.Add("DisplayAddInfo2", typeof(string));          // 열람권한
                        dtList.Columns.Add("DisplayAddInfo3", typeof(string));          // 보존년한
                        dtList.Columns.Add("DisplayAddInfo4", typeof(string));          // 문서등급
                        dtList.Columns.Add("DisplayAddInfo5", typeof(string));          // 문서분류

                        foreach (DataRow dr in dtList.Rows)
                        {
                            string usageOrg = dr["UsageOrg"].ToString();
                            string displayUsage = "";

                            if (usageOrg == "0")
                            {
                                displayUsage = "테스트 작성중";
                            }
                            else if (usageOrg == "1")
                            {
                                displayUsage = "테스트 사용중";
                            }
                            else if (usageOrg == "7")
                            {
                                displayUsage = "사용중";
                            }
                            else if (usageOrg == "9")
                            {
                                displayUsage = "사용안함";
                            }
                            else
                            {
                                displayUsage = usageOrg;
                            }

                            dr["DisplayUsage"] = displayUsage;
                            dr["DisplayPageSet"] = (String.Compare(dr["Reserved1"].ToString(), "w", true) == 0) ? "가로" : "세로";

                            string reserved2 = StringHelper.SafeString(dr["Reserved2"]);

                            if (!String.IsNullOrWhiteSpace(reserved2))
                            {
                                dr["DisplayAddInfo1"] = (reserved2.Split(';').Length > 0) ? dr["Reserved2"].ToString().Split(';')[0] : "";
                                dr["DisplayAddInfo2"] = (reserved2.Split(';').Length > 1) ? dr["Reserved2"].ToString().Split(';')[1] : "";
                                dr["DisplayAddInfo3"] = (reserved2.Split(';').Length > 2) ? dr["Reserved2"].ToString().Split(';')[2] : "";
                                dr["DisplayAddInfo4"] = (reserved2.Split(';').Length > 3) ? dr["Reserved2"].ToString().Split(';')[3] : "";
                                dr["DisplayAddInfo5"] = (reserved2.Split(';').Length > 4) ? dr["Reserved2"].ToString().Split(';')[4] : "";
                            }
                            else
                            {
                                dr["DisplayAddInfo1"] = "";
                                dr["DisplayAddInfo2"] = "";
                                dr["DisplayAddInfo3"] = "";
                                dr["DisplayAddInfo4"] = "";
                                dr["DisplayAddInfo5"] = "";
                            }
                        }

                        dtList.AcceptChanges();
                        ViewData["formlist"] = dtList;
                    }
                }
            }

            return View();
        }

        /// <summary>
        /// 양식폼 Reserved2 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateOptionInfo()
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

                string formID = StringHelper.SafeString(jPost["formID"].ToString());
                string targetField = "Reserved2";
                string targetValue = StringHelper.SafeString(jPost["targetValue"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.UpdateEAFormFieldValue(formID, targetField, targetValue);
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

        #region [ /Woa/App/Notice ]

        public ActionResult Notice()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            ViewData["Item1"] = "";
            ViewData["Item3"] = "";
            ViewData["ItemMailUse"] = "";
            ViewData["ItemPeriod"] = "";
            ViewData["ItemField"] = "";
            ViewData["ItemDeferment"] = "";

            // 코드 정보 조회
            using (CommonBiz commonBiz = new CommonBiz())
            {
                ServiceResult resultCode = commonBiz.SelectCodeDescription("ea", "notice", "");

                if (resultCode?.ResultDataTable?.Rows?.Count > 0)
                {
                    DataRow dr = resultCode.ResultDataTable.Rows[0];

                    ViewData["Item1"] = StringHelper.SafeString(dr["Item1"]);
                    ViewData["Item3"] = StringHelper.SafeString(dr["Item3"]);

                    string item2 = StringHelper.SafeString(dr["Item2"]);

                    ViewData["ItemMailUse"] = item2.Split(';')[0];
                    ViewData["ItemPeriod"] = item2.Split(';')[1];
                    ViewData["ItemField"] = item2.Split(';')[2];
                    ViewData["ItemDeferment"] = item2.Split(';')[3];
                }
            }

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 양식 분류 조회
                ServiceResult resultClass = eApprovalBiz.SelectEAFormClass(domainID);

                if (resultClass.ResultCode == 0 && resultClass.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["formclass"] = resultClass.ResultDataTable;
                }

                // 양식 문서 리스트 조회
                ServiceResult resultList = eApprovalBiz.SelectEAFormList(domainID);

                if (resultList.ResultCode == 0)
                {
                    if (resultList.ResultCode == 0 && resultList.ResultDataTable?.Rows?.Count > 0)
                    {
                        DataTable dtList = resultList.ResultDataTable;

                        dtList.Columns.Add("FormSet", typeof(string));
                        dtList.Columns.Add("MailUse", typeof(string));
                        dtList.Columns.Add("Period", typeof(string));
                        dtList.Columns.Add("Field", typeof(string));
                        dtList.Columns.Add("Deferment", typeof(int));

                        foreach (DataRow dr in dtList.Rows)
                        {
                            dr["FormSet"] = "N";
                            dr["MailUse"] = StringHelper.SafeString(ViewData["ItemMailUse"]);
                            dr["Period"] = StringHelper.SafeString(ViewData["ItemPeriod"]);
                            dr["Field"] = StringHelper.SafeString(ViewData["ItemField"]);
                            dr["Deferment"] = StringHelper.SafeInt(ViewData["ItemDeferment"]);
                        }

                        // 양식 알림 조회
                        ServiceResult resultNotice = eApprovalBiz.SelectEAFormNotice("");

                        if (resultNotice.ResultCode == 0 && resultNotice.ResultDataTable?.Rows?.Count > 0)
                        {
                            foreach (DataRow dr in dtList.Rows)
                            {
                                DataRow matchDr = resultNotice.ResultDataTable.AsEnumerable().FirstOrDefault(x => StringHelper.SafeString(x["FormID"]) == StringHelper.SafeString(dr["FormID"]));

                                if (matchDr != null && String.Compare(StringHelper.SafeString(matchDr["FormSet"]), "Y", true) == 0)
                                {
                                    dr["FormSet"] = matchDr["FormSet"];
                                    dr["MailUse"] = matchDr["MailUse"];
                                    dr["Period"] = matchDr["Period"];
                                    dr["Field"] = matchDr["Field"];
                                    dr["Deferment"] = matchDr["Deferment"];
                                }
                            }
                        }

                        dtList.AcceptChanges();
                        ViewData["formlist"] = dtList;
                    }
                }
            }

            return View();
        }

        /// <summary>
        /// 양식 알림 FormSet 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateNoticeFormInfo()
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

                string formID = StringHelper.SafeString(jPost["formID"].ToString());
                int period = StringHelper.SafeInt(jPost["period"].ToString());
                string field = StringHelper.SafeString(jPost["field"].ToString());
                int deferment = StringHelper.SafeInt(jPost["deferment"].ToString());
                string mailuse = StringHelper.SafeString(jPost["mailuse"].ToString());
                
                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.UpdateEAFormNoticeFormSet(formID, period, field, deferment, mailuse);
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
        /// 양식 알림 FormSet 삭제
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string DeleteNoticeFormInfo()
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

                string formID = StringHelper.SafeString(jPost["formID"].ToString());

                ServiceResult result = new ServiceResult();

                using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
                {
                    result = eApprovalBiz.DeleteEAFormNoticeFormSet(formID);
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
        /// 기본 알림 설정 정보 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateNoticeBaseSet()
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
                    result = commonBiz.HandleCodeDescription("U", key1, key2, key3, item1, item2, item3, item4, item5);
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

        #region [ /Woa/App/Form ]

        public ActionResult Form(int mid = 0, int oid = 0)
        {
            if (mid == 0 || oid == 0)
            {
                return Redirect("/Woa/app");
            }

            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
            string companyCode = StringHelper.SafeString(Session["CompanyCode"].ToString());
            //string frontName = StringHelper.SafeString(Session["FRONTNAME"].ToString());
            string frontName = "Zumwork";
            string eaFormFolder = StringHelper.SafeString(WebConfigurationManager.AppSettings["EAFormFolder"]);
            string eaFormSchemaPath = StringHelper.SafeString(WebConfigurationManager.AppSettings["EAFormSchemaPath"]);

            ServiceResult result = new ServiceResult();

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                result = eApprovalBiz.SelectXFFormInstanceDefinition(domainID, "ea", mid);

                if (result.ResultCode == 0 && result.ResultDataDetail?.Count == 2)
                {
                    XFormInstance xformIns = (XFormInstance)result.ResultDataDetail["xformIns"];
                    XFormDefinition xformDef = (XFormDefinition)result.ResultDataDetail["xformDef"];

                    result = eApprovalBiz.ParsingXFormToHTML(companyCode, xformDef, xformIns, oid, "ea", domainID.ToString(), frontName, "BizForce", eaFormSchemaPath, eaFormFolder);
                }
            }

            if (result.ResultCode == 0 && !String.IsNullOrWhiteSpace(result.ResultDataString))
            {
                Response.Clear();
                Response.Charset = "utf-8";
                Response.Buffer = true;

                Response.ContentType = "application/unknown";
                Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;
                Response.Write(result.ResultDataString);
                Response.End();
            }

            return View();
        }

        #endregion
    }
}