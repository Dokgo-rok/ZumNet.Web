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
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class OrganController : ControllerWebBase
    {
        // GET: WoA/Organ
        public ActionResult Index()
        {
            return View();
        }

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

        [Authorize]
        public ActionResult Dept()
        {
            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                result = commonBiz.GetContainer("1", 13);
            }

            if (result.ResultCode == 0)
            {
                return View(result.ResultDataTable);
            }

            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchUserInfoJson()
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
                    ItemCount = result.ResultItemCount;
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
        public string SearchRetiredUserInfoJson()
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
                    ItemCount = result.ResultItemCount;
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
        public string SearchGroupInfoJson()
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

                string searchText = StringHelper.SafeString(jPost["searchText"].ToString());

                if (!String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = $" AND a.DisplayName LIKE '%{searchText}%'";
                }

                using (OfficePortalBiz portalBiz = new OfficePortalBiz())
                {
                    result = portalBiz.SearchDomainGroups(StringHelper.SafeString(jPost["domainID"].ToString())
                            , StringHelper.SafeString(jPost["memberOf"].ToString())
                            , StringHelper.SafeString(jPost["groupType"].ToString())
                            , StringHelper.SafeString(jPost["sortColumn"].ToString())
                            , StringHelper.SafeString(jPost["sortType"].ToString())
                            , searchText
                            , StringHelper.SafeString(jPost["admin"].ToString()));
                }

                if (result.ResultCode == 0)
                {
                    ItemCount = result.ResultItemCount;
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
        public string SearchDeletedGroupInfoJson()
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
                    result = commonBiz.GetDeletedGroups(StringHelper.SafeString(jPost["domainID"].ToString())
                            , StringHelper.SafeString(jPost["groupType"].ToString())
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
                    ItemCount = result.ResultItemCount;
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
        public string SearchGroupMemberInfoJson()
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

                using (OfficePortalBiz portalBiz = new OfficePortalBiz())
                {
                    result = portalBiz.GetGroupMemberList(StringHelper.SafeString(jPost["domainID"].ToString())
                            , StringHelper.SafeString(jPost["groupID"].ToString())
                            , DateTime.Now.ToString("yyyy-MM-dd")
                            , StringHelper.SafeString(jPost["sort"].ToString())
                            , StringHelper.SafeString(jPost["order"].ToString())
                            , StringHelper.SafeString(jPost["admin"].ToString()));
                }

                if (result.ResultCode == 0)
                {
                    ItemCount = result.ResultItemCount;
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
        public string CheckObjectDoubleAliasJson()
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
    }
}