using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class OrganController : ControllerWebBase
    {
        #region [ /Woa/Organ/Index ]

        // GET: WoA/Organ
        [Authorize]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchUserInfo()
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

                string searchType = StringHelper.SafeString(jPost["searchType"].ToString());
                string searchText = StringHelper.SafeString(jPost["searchText"].ToString());

                if (!String.IsNullOrWhiteSpace(searchText))
                {
                    if (String.IsNullOrWhiteSpace(searchType) || String.Compare(searchType, "account", true) == 0)
                    {
                        searchText = $" AND (DisplayName LIKE '%{searchText}%' OR LogonID LIKE '%{searchText}%')";
                    }
                    else if (String.Compare(searchType, "name", true) == 0)
                    {
                        switch (searchText)
                        {
                            case "ㄱ":
                                searchText = " AND DisplayName between '가' and '깋'";
                                break;
                            case "ㄴ":
                                searchText = " AND DisplayName between '나' and '닣'";
                                break;
                            case "ㄷ":
                                searchText = " AND DisplayName between '다' and '딯'";
                                break;
                            case "ㄹ":
                                searchText = " AND DisplayName between '라' and '맇'";
                                break;
                            case "ㅁ":
                                searchText = " AND DisplayName between '마' and '밓'";
                                break;
                            case "ㅂ":
                                searchText = " AND DisplayName between '바' and '빟'";
                                break;
                            case "ㅅ":
                                searchText = " AND DisplayName between '사' and '싷'";
                                break;
                            case "ㅇ":
                                searchText = " AND DisplayName between '아' and '잏'";
                                break;
                            case "ㅈ":
                                searchText = " AND DisplayName between '자' and '짛'";
                                break;
                            case "ㅊ":
                                searchText = " AND DisplayName between '차' and '칳'";
                                break;
                            case "ㅋ":
                                searchText = " AND DisplayName between '카' and '킿'";
                                break;
                            case "ㅌ":
                                searchText = " AND DisplayName between '타' and '팋'";
                                break;
                            case "ㅍ":
                                searchText = " AND DisplayName between '파' and '핗'";
                                break;
                            case "ㅎ":
                                searchText = " AND DisplayName between '하' and '힣'";
                                break;
                            default:
                                searchText = $" AND DisplayName LIKE '{searchText}%'";
                                break;
                        }
                    }
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.SearchDomainUsers(StringHelper.SafeString(jPost["domainID"].ToString())
                            , StringHelper.SafeString(jPost["groupID"].ToString())
                            , StringHelper.SafeString(jPost["groupType"].ToString())
                            , StringHelper.SafeInt(jPost["pageIndex"].ToString())
                            , StringHelper.SafeInt(jPost["pageCount"].ToString())
                            , StringHelper.SafeString(jPost["sortColumn"].ToString())
                            , StringHelper.SafeString(jPost["sortType"].ToString())
                            , searchText
                            , StringHelper.SafeString(jPost["admin"].ToString()));
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

        [HttpPost]
        [Authorize]
        public string SearchRetiredUserInfo()
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

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.SearchBaseRetiredUsers(StringHelper.SafeString(jPost["domainID"].ToString())
                            , StringHelper.SafeInt(jPost["pageIndex"].ToString())
                            , StringHelper.SafeInt(jPost["pageCount"].ToString())
                            , StringHelper.SafeString(jPost["sortColumn"].ToString())
                            , StringHelper.SafeString(jPost["sortType"].ToString())
                            , StringHelper.SafeString(jPost["searchColumn"].ToString())
                            , StringHelper.SafeString(jPost["searchText"].ToString())
                            , StringHelper.SafeString(jPost["searchStartDate"].ToString())
                            , StringHelper.SafeString(jPost["searchEndDate"].ToString()));
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

        #region [ /Woa/Organ/Member ]

        // GET: WoA/Organ/Member
        [Authorize]
        public ActionResult Member(int id = 0)
        {
            if (id == 0)
            {
                return View();
            }

            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                result = commonBiz.GetUserTotalInfo(id, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            }

            if (result.ResultCode == 0)
            {
                if (result?.ResultDataSet?.Tables?.Count > 0)
                {
                    DataTable dtUser = result.ResultDataSet.Tables[1];

                    dtUser.Columns.Add("b_IsGw", typeof(bool));
                    dtUser.Columns.Add("b_IsPDM", typeof(bool));
                    dtUser.Columns.Add("b_IsERP", typeof(bool));
                    dtUser.Columns.Add("b_IsMSG", typeof(bool));

                    dtUser.Rows[0]["b_IsGw"] = (String.Compare(dtUser.Rows[0]["IsGw"].ToString(), "Y", true) == 0);
                    dtUser.Rows[0]["b_IsPDM"] = (String.Compare(dtUser.Rows[0]["IsPDM"].ToString(), "Y", true) == 0);
                    dtUser.Rows[0]["b_IsERP"] = (String.Compare(dtUser.Rows[0]["IsERP"].ToString(), "Y", true) == 0);
                    dtUser.Rows[0]["b_IsMSG"] = (String.Compare(dtUser.Rows[0]["IsMSG"].ToString(), "Y", true) == 0);
                }

                return View(result.ResultDataSet);
            }

            return View();
        }

        #endregion

        #region [ /Woa/Organ/Grade ]

        // GET: WoA/Organ/Grade
        [Authorize]
        public ActionResult Grade()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchGradeInfo()
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

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetGradeCode(StringHelper.SafeString(jPost["actionKind"].ToString())
                            , StringHelper.SafeInt(jPost["domainID"].ToString())
                            , StringHelper.SafeString(jPost["codeType"].ToString()));
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

        [HttpPost]
        [Authorize]
        public string HandleGradeCode()
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
                int domainID = StringHelper.SafeInt(jPost["domainID"].ToString());
                string type = StringHelper.SafeString(jPost["type"].ToString());
                string code = StringHelper.SafeString(jPost["code"].ToString());
                string newType = StringHelper.SafeString(jPost["newType"].ToString());
                string newCode = StringHelper.SafeString(jPost["newCode"].ToString());
                string codeName = StringHelper.SafeString(jPost["codeName"].ToString());
                string inUse = StringHelper.SafeString(jPost["inUse"].ToString());
                string removeInfo = "";

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.HandleGradeCode(actionKind, domainID, type, code, newType, newCode, codeName, inUse, removeInfo);
                }

                if (result.ResultCode == 0)
                {
                    ResultMessage = result.ResultDataString;

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

        #region [ /Woa/Organ/Map ]

        // GET: WoA/Organ/Map
        [Authorize]
        public ActionResult Map()
        {
            List<WebTreeList> listTree = new List<WebTreeList>();

            WebTreeList treeInfo = new WebTreeList();
            treeInfo.id = "0";
            treeInfo.parent = "#";
            treeInfo.state = new Dictionary<string, bool>();
            treeInfo.state.Add("opened", true);
            treeInfo.text = "조직도";

            listTree.Add(treeInfo);

            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
            int memberOf = 0;
            string groupType = "D";
            int groupID = 0;
            string viewDate = DateTime.Now.ToString("yyyy-MM-dd");
            string admin = "Y";

            ServiceResult result = new ServiceResult();

            using (OfficePortalBiz portalBiz = new OfficePortalBiz())
            {
                // 부서 정보 조회
                result = portalBiz.GetAdminOrgMapInfo(domainID, memberOf, groupType, groupID, viewDate, admin);

                if (result.ResultCode == 0 && result.ResultDataSet?.Tables?.Count > 1)
                {
                    foreach (DataRow dr in result.ResultDataSet.Tables[1].Rows)
                    {
                        treeInfo = new WebTreeList();
                        treeInfo.id = StringHelper.SafeString(dr["GR_ID"].ToString());
                        treeInfo.parent = StringHelper.SafeString(dr["MemberOf"].ToString());
                        treeInfo.state = new Dictionary<string, bool>();
                        treeInfo.state.Add("opened", false);
                        treeInfo.text = StringHelper.SafeString(dr["DisplayName"].ToString());

                        listTree.Add(treeInfo);                        
                    }
                }
            }

            ViewData["deptlist"] = JsonConvert.SerializeObject(listTree);

            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchGroupMemberInfo()
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
                int groupID = StringHelper.SafeInt(jPost["groupID"].ToString());
                string viewDate = DateTime.Now.ToString("yyyy-MM-dd");

                ServiceResult result = new ServiceResult();

                using (OfficePortalBiz portalBiz = new OfficePortalBiz())
                {
                    result = portalBiz.GetGroupMemberList(domainID.ToString(), groupID.ToString(), viewDate, "", "", "Y");
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

        #region [ /Woa/Organ/Group ]

        // GET: WoA/Organ/Group
        [Authorize]
        public ActionResult Group()
        {
            List<WebTreeList> listTree = new List<WebTreeList>();

            WebTreeList treeInfo = new WebTreeList();
            treeInfo.id = "0";
            treeInfo.parent = "#";
            treeInfo.state = new Dictionary<string, bool>();
            treeInfo.state.Add("opened", true);
            treeInfo.text = "전체 그룹";

            listTree.Add(treeInfo);

            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                result = commonBiz.GetContainer(domainID.ToString(), 13);

                if (result.ResultCode == 0 && result.ResultDataTable?.Rows?.Count > 0)
                {
                    foreach (DataRow dr in result.ResultDataTable.Rows)
                    {
                        // 부서 그룹은 별도 메뉴가 있으므로 제외
                        if (String.Compare(StringHelper.SafeString(dr["Command"].ToString()), "org.gr.dept", true) == 0)
                        {
                            continue;
                        }

                        treeInfo = new WebTreeList();
                        treeInfo.id = StringHelper.SafeString(dr["Command"].ToString());
                        treeInfo.parent = "0";
                        treeInfo.state = new Dictionary<string, bool>();
                        treeInfo.state.Add("opened", false);
                        treeInfo.text = StringHelper.SafeString(dr["DisplayName"].ToString());

                        listTree.Add(treeInfo);
                    }
                }
            }

            ViewData["grouplist"] = JsonConvert.SerializeObject(listTree);

            return View();
        }

        #endregion

        #region [ /Woa/Organ/Dept ]

        // GET: WoA/Organ/Dept
        [Authorize]
        public ActionResult Dept()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchGroupInfo()
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

                ServiceResult result = new ServiceResult();

                int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
                string groupType = StringHelper.SafeString(jPost["groupType"].ToString());

                using (OfficePortalBiz portalBiz = new OfficePortalBiz())
                {
                    result = portalBiz.SearchDomainGroups(domainID.ToString(), "", groupType, "", "", "", "Y");
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

        [HttpPost]
        [Authorize]
        public string SearchDeletedGroupInfo()
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
                string groupType = StringHelper.SafeString(jPost["groupType"].ToString());

                ServiceResult result = new ServiceResult();
                
                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetDeletedGroups(domainID.ToString(), groupType, 1, 10000, "", "", "", "", "", "");
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
                ResultMessage = "SP 조회 오류";
            }

            return CreateJsonData();
        }

        [HttpPost]
        [Authorize]
        public string SelectDeptGroupTotalInfo()
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

                int groupID = StringHelper.SafeInt(jPost["GR_ID"].ToString());
                string viewDate = DateTime.Now.ToString("yyyy-MM-dd");

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetGroupInfo(groupID, viewDate);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = result.ResultItemCount;
                    ResultData = JsonConvert.SerializeObject(result.ResultDataSet);

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

        [HttpPost]
        [Authorize]
        public string CheckObjectDoubleAlias()
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

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.CheckDoubleAlias(StringHelper.SafeString(jPost["alias"].ToString())
                            , StringHelper.SafeString(jPost["objectType"].ToString()));
                }

                if (result.ResultCode == 0)
                {
                    ResultMessage = result.ResultMessage;

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

        [HttpPost]
        [Authorize]
        public string HandleGroup()
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
                int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
                string groupType = StringHelper.SafeString(jPost["groupType"].ToString());
                string groupAlias = StringHelper.SafeString(jPost["groupAlias"].ToString());
                string parentAlias = StringHelper.SafeString(jPost["parentAlias"].ToString());
                string groupName = StringHelper.SafeString(jPost["groupName"].ToString());
                string groupShortName = StringHelper.SafeString(jPost["groupShortName"].ToString());
                int sortKey = StringHelper.SafeInt(jPost["sortKey"].ToString());
                string pdmgrCode = StringHelper.SafeString(jPost["pdmgrCode"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    if (String.Compare(mode, "I", true) == 0)
                    {
                        result = commonBiz.CreateGroup(domainID, groupType, groupAlias, parentAlias, groupName, groupShortName, sortKey, pdmgrCode);
                    }
                    else if (String.Compare(mode, "U", true) == 0)
                    {
                        // 이것저것 한꺼번에 저장 필요
                        //result = commonBiz.CreateGroup(domainID, groupType, groupAlias, parentAlias, groupName, groupShortName, sortKey, pdmgrCode);
                    }
                }

                if (result.ResultCode == 0)
                {
                    ResultMessage = result.ResultDataString;

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
    }
}