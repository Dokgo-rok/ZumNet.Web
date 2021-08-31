using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
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
                string formId = StringHelper.SafeString(Request.Form["formId"]);
                int defId = StringHelper.SafeInt(Request.Form["defId"]);
                int viewer = StringHelper.SafeInt(Request.Form["viewer"]);
                int state = StringHelper.SafeInt(Request.Form["state"]);
                int page = StringHelper.SafeInt(Request.Form["draw"]);
                int count = StringHelper.SafeInt(Request.Form["length"]);
                string sortCol = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchCol = StringHelper.SafeString(Request.Form["searchCol"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStart = StringHelper.SafeString(Request.Form["searchStart"]);
                string searchEnd = StringHelper.SafeString(Request.Form["searchEnd"]);
                string prevSortColumn = StringHelper.SafeString(Request.Form["prevSortColumn"]);             // 이전 소트 컬럼
                string prevSortType = StringHelper.SafeString(Request.Form["prevSortColumn"]);               // 이전 소트 타입

                if (page == 0)
                {
                    page = 1;
                }

                if (count == 0)
                {
                    count = 20;
                }

                switch (sortCol)
                {
                    case "0":
                        sortCol = "OID";
                        break;
                    case "1":
                        sortCol = "DocName";
                        break;
                    case "2":
                        sortCol = "PIState";
                        break;
                    case "3":
                        sortCol = "PIName";
                        break;
                    case "4":
                        sortCol = "CreatorDept";
                        break;
                    case "5":
                        sortCol = "Creator";
                        break;
                    case "6":
                        sortCol = "CreateDate";
                        break;
                    case "7":
                        sortCol = "PIEnd";
                        break;
                    case "8":
                        sortCol = "DeleteDate";
                        break;
                    case "9":
                        sortCol = "DocStatus";
                        break;
                    default:
                        break;
                }

                // 페이지 최초 진입시
                if (String.IsNullOrWhiteSpace(prevSortColumn))
                {
                    sortCol = "CreateDate";
                    sortType = "desc";
                }
                else
                {
                    // sortcolumn이 같지 않으면 페이지를 1로
                    // sortType이 같지 않으면 페이지를 1로
                    if (String.Compare(sortCol, prevSortColumn, true) != 0 || String.Compare(sortType, prevSortType, true) != 0)
                    {
                        page = 1;
                    }
                    else
                    {
                        page++;
                    }
                }

                if (String.IsNullOrWhiteSpace(searchCol) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (WorkList workList = new WorkList())
                {
                    result = workList.ViewListPerMenu(mode, admin, formId, defId, viewer, state, page, count, sortCol, sortType, searchCol, searchText, searchStart, searchEnd);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = result.ResultItemCount;
                    ResultItemFilteredCount = ResultItemCount;
                    ResultPageIndex = page;
                    ResultSortColumn = sortCol;
                    ResultSortType = sortType;
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
            }

            return View();
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

                        string chargeDeptDisplayList = "";
                        string chargeMemberDisplayList = "";
                        string chargeDeptList = "";
                        string chargeMemberList = "";

                        foreach (DataRow dr in dtList.Rows)
                        {
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
        /// 담당자 업데이트
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateChargeInfo()
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
                string chargeJson = StringHelper.SafeString(jPost["chargeJson"].ToString());

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

        public ActionResult Charge1()
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
                        dtList.Columns.Add("ChargeDept", typeof(string));
                        dtList.Columns.Add("ChargeMember", typeof(string));

                        string chargeDeptList = "";
                        string chargeMemberList = "";

                        foreach (DataRow dr in dtList.Rows)
                        {
                            if (dtChargeDeptList?.Rows?.Count > 0)
                            {
                                if (dtChargeDeptList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).Count() > 0)
                                {
                                    chargeDeptList = String.Join(",", dtChargeDeptList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => StringHelper.SafeString(x["ChargeID"])));
                                }

                            }

                            if (dtChargeMemberList?.Rows?.Count > 0)
                            {
                                if (dtChargeMemberList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).Count() > 0)
                                {
                                    chargeMemberList = String.Join(",", dtChargeMemberList.AsEnumerable().Where(x => String.Compare(StringHelper.SafeString(x["FormID"]), StringHelper.SafeString(dr["FormID"]), true) == 0).CopyToDataTable().AsEnumerable().Select(x => StringHelper.SafeString(x["ChargeID"])));
                                }
                            }

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

        #endregion
    }
}