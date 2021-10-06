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
            string actionKind = "2";
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());
            string codeType = "";
            string groupType = "D";

            ServiceResult resultGrade = new ServiceResult();
            ServiceResult resultDept = new ServiceResult();
            ServiceResult resultFolder = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                resultGrade = commonBiz.GetGradeCode(actionKind, domainID, codeType);

                if (resultGrade.ResultCode == 0 && resultGrade.ResultItemCount > 0)
                {
                    ViewBag.grade = JsonConvert.SerializeObject(resultGrade.ResultDataTable);
                }

                resultFolder = commonBiz.GetSearchFolder(domainID, 0, "", "N");
                resultFolder.ResultDataTable.TableName = "dtFolder";
            }

            using (OfficePortalBiz portalBiz = new OfficePortalBiz())
            {
                resultDept = portalBiz.SearchDomainGroups(domainID.ToString(), "", groupType, "", "", "", "Y");
                resultDept.ResultDataTable.TableName = "dtDept";
            }

            DataSet dsResult = new DataSet();
            dsResult.Tables.Add(resultDept.ResultDataTable.Copy());
            dsResult.Tables.Add(resultFolder.ResultDataTable.Copy());

            return View(dsResult);
        }

        /// <summary>
        /// 사용자 검색
        /// </summary>
        /// <returns></returns>
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

        /// <summary>
        /// 퇴직자 검색
        /// </summary>
        /// <returns></returns>
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

        /// <summary>
        /// 사용자 정보 조회
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string GetUserTotalInfo()
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

                int userID = StringHelper.SafeInt(jPost["userID"].ToString());
                string viewDate = DateTime.Now.ToString("yyyy-MM-dd");

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetUserTotalInfo(userID, viewDate);
                }

                if (result.ResultCode == 0)
                {
                    //if (result?.ResultDataSet?.Tables?.Count > 0)
                    //{
                    //    DataTable dtUser = result.ResultDataSet.Tables[1];

                    //    dtUser.Columns.Add("b_IsGw", typeof(bool));
                    //    dtUser.Columns.Add("b_IsPDM", typeof(bool));
                    //    dtUser.Columns.Add("b_IsERP", typeof(bool));
                    //    dtUser.Columns.Add("b_IsMSG", typeof(bool));

                    //    dtUser.Rows[0]["b_IsGw"] = (String.Compare(dtUser.Rows[0]["IsGw"].ToString(), "Y", true) == 0);
                    //    dtUser.Rows[0]["b_IsPDM"] = (String.Compare(dtUser.Rows[0]["IsPDM"].ToString(), "Y", true) == 0);
                    //    dtUser.Rows[0]["b_IsERP"] = (String.Compare(dtUser.Rows[0]["IsERP"].ToString(), "Y", true) == 0);
                    //    dtUser.Rows[0]["b_IsMSG"] = (String.Compare(dtUser.Rows[0]["IsMSG"].ToString(), "Y", true) == 0);
                    //}


                    ResultItemCount = result.ResultItemCount;
                    ResultData = JsonConvert.SerializeObject(result);

                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = "사용자 정보를 조회하는데 실패하였습니다.";
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
        /// 신규 사용자 추가
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string CreateMember()
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

                string memberJson = StringHelper.SafeString(jObj["memberJson"].ToString());

                // 다시 파싱
                JObject jObjMember = JObject.Parse(memberJson);

                string logonID = StringHelper.SafeString(jObjMember["LogonID"]);
                string mailAccount = logonID;
                string domainAlias = StringHelper.SafeString(jObjMember["DomainAlias"]);
                string displayName = StringHelper.SafeString(jObjMember["DisplayName"]);
                string employeeID = StringHelper.SafeString(jObjMember["EmployeeID"]);
                string isLive = StringHelper.SafeString(jObjMember["IsLive"]);
                string mailServer = StringHelper.SafeString(jObjMember["MailServer"]);
                string ouName = StringHelper.SafeString(jObjMember["OUName"]);
                string longName = StringHelper.SafeString(jObjMember["LongName"]);
                string firstName = StringHelper.SafeString(jObjMember["FirstName"]);
                string lastName = StringHelper.SafeString(jObjMember["LastName"]);
                string joinDate = StringHelper.SafeString(jObjMember["JoinDate"]);
                string groupAlias = StringHelper.SafeString(jObjMember["GroupAlias"]);
                string groupID = StringHelper.SafeString(jObjMember["GroupID"]);
                string role = StringHelper.SafeString(jObjMember["Role"]);
                string gradeCode1 = StringHelper.SafeString(jObjMember["GradeCode1"]);
                string gradeCode2 = StringHelper.SafeString(jObjMember["GradeCode2"]);
                string gradeCode3 = StringHelper.SafeString(jObjMember["GradeCode3"]);
                string gradeCode4 = StringHelper.SafeString(jObjMember["GradeCode4"]);
                string gradeCode5 = StringHelper.SafeString(jObjMember["GradeCode5"]);
                string personNo1 = StringHelper.SafeString(jObjMember["PersonNo1"]);
                string personNo2 = StringHelper.SafeString(jObjMember["PersonNo2"]);
                string birth = StringHelper.SafeString(jObjMember["Birth"]);
                string birthType = StringHelper.SafeString(jObjMember["BirthType"]);
                string mobile = StringHelper.SafeString(jObjMember["Mobile"]);
                string telephone = StringHelper.SafeString(jObjMember["Telephone"]);
                string fax = StringHelper.SafeString(jObjMember["Fax"]);
                string homePhone = StringHelper.SafeString(jObjMember["HomePhone"]);
                string homePage = StringHelper.SafeString(jObjMember["HomePage"]);
                string zipCode1 = StringHelper.SafeString(jObjMember["ZipCode1"]);
                string address1 = StringHelper.SafeString(jObjMember["Address1"]);
                string detailAddress1 = StringHelper.SafeString(jObjMember["DetailAddress1"]);
                string company = StringHelper.SafeString(jObjMember["Company"]);
                string zipCode2 = StringHelper.SafeString(jObjMember["ZipCode2"]);
                string address2 = StringHelper.SafeString(jObjMember["Address2"]);
                string detailAddress2 = StringHelper.SafeString(jObjMember["DetailAddress2"]);
                string themePath = StringHelper.SafeString(jObjMember["ThemePath"]);
                themePath = (String.IsNullOrWhiteSpace(themePath)) ? "11" : themePath;              // HARDCODING
                string keyword1 = StringHelper.SafeString(jObjMember["Keyword1"]);
                string keyword2 = StringHelper.SafeString(jObjMember["Keyword2"]);
                string keyword3 = StringHelper.SafeString(jObjMember["Keyword3"]);
                string keyword4 = StringHelper.SafeString(jObjMember["Keyword4"]);
                string keyword5 = StringHelper.SafeString(jObjMember["Keyword5"]);
                string keyword6 = StringHelper.SafeString(jObjMember["Keyword6"]);
                string keyword7 = StringHelper.SafeString(jObjMember["Keyword7"]);
                string isInsa = StringHelper.SafeString(jObjMember["IsInsa"]);
                string secondMail = StringHelper.SafeString(jObjMember["SecondMail"]);
                string isGW = StringHelper.SafeString(jObjMember["IsGW"]);
                string isPDM = StringHelper.SafeString(jObjMember["IsPDM"]);
                string isERP = StringHelper.SafeString(jObjMember["IsERP"]);
                string isMSG = StringHelper.SafeString(jObjMember["IsMSG"]);

                // PDM, ERP 체크 생략(Controller 단에서 처리 - 신규 생성이므로 체크 여부에 따라 중복 체크하면 됨)
                bool isExistsGW = false;

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    isExistsGW = commonBiz.CheckUserAlias(logonID);
                }

                if (isExistsGW)
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"ID ({logonID})은(는) 이미 존재하는 계정입니다.";

                    return CreateJsonData();
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.CreateUser(logonID, mailAccount, domainAlias, displayName, employeeID
                                                , isLive, mailServer, ouName, longName, firstName, lastName
                                                , joinDate, groupAlias, groupID, role, gradeCode1, gradeCode2
                                                , gradeCode3, gradeCode4, gradeCode5, personNo1, personNo2, birth
                                                , birthType, mobile, telephone, fax, homePhone, homePage, zipCode1
                                                , address1, detailAddress1, company, zipCode2, address2, detailAddress2
                                                , themePath, keyword1, keyword2, keyword3, keyword4, keyword5, keyword6
                                                , keyword7, isInsa, secondMail, isGW, isPDM, isERP, isMSG);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"사용자 생성에 실패하였습니다. :: {result.ResultMessage}";
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
        /// 사용자 기본 정보 변경
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateBasicUserInfo()
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

                string memberJson = StringHelper.SafeString(jObj["memberJson"].ToString());

                // 다시 파싱
                JObject jObjMember = JObject.Parse(memberJson);

                int userID = StringHelper.SafeInt(jObjMember["UserID"]);
                string displayName = StringHelper.SafeString(jObjMember["DisplayName"]);
                string longName = StringHelper.SafeString(jObjMember["LongName"]);
                string firstName = StringHelper.SafeString(jObjMember["FirstName"]);
                string lastName = StringHelper.SafeString(jObjMember["LastName"]);
                string employeeID = StringHelper.SafeString(jObjMember["EmployeeID"]);
                string joinDate = StringHelper.SafeString(jObjMember["JoinDate"]);
                string secondMail = StringHelper.SafeString(jObjMember["SecondMail"]);
                string gradeCode1 = StringHelper.SafeString(jObjMember["GradeCode1"]);
                string gradeCode2 = StringHelper.SafeString(jObjMember["GradeCode2"]);
                string gradeCode3 = "";
                string gradeCode4 = "";
                string gradeCode5 = "";
                string isGW = StringHelper.SafeString(jObjMember["IsGW"]);
                string isPDM = StringHelper.SafeString(jObjMember["IsPDM"]);
                string isERP = StringHelper.SafeString(jObjMember["IsERP"]);
                string isMSG = StringHelper.SafeString(jObjMember["IsMSG"]);
                
                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    commonBiz.UpdateURBasicInfo(userID, displayName, longName, firstName, lastName, employeeID, joinDate, secondMail, gradeCode1, gradeCode2, gradeCode3, gradeCode4, gradeCode5, isGW, isPDM, isERP, isMSG);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"사용자 정보 수정에 실패하였습니다. :: {result.ResultMessage}";
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
        /// 사용자 상세 정보 변경
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateDetail1UserInfo()
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

                string memberJson = StringHelper.SafeString(jObj["memberJson"].ToString());

                // 다시 파싱
                JObject jObjMember = JObject.Parse(memberJson);

                int userID = StringHelper.SafeInt(jObjMember["UserID"]);
                string personNo1 = StringHelper.SafeString(jObjMember["PersonNo1"]);
                string personNo2 = StringHelper.SafeString(jObjMember["PersonNo2"]);
                string birth = StringHelper.SafeString(jObjMember["Birth"]);
                string birthType = StringHelper.SafeString(jObjMember["BirthType"]);
                string mobile = StringHelper.SafeString(jObjMember["Mobile"]);
                string telephone = StringHelper.SafeString(jObjMember["Telephone"]);
                string keyword1 = StringHelper.SafeString(jObjMember["Keyword1"]);
                string keyword2 = StringHelper.SafeString(jObjMember["Keyword2"]);
                string keyword3 = StringHelper.SafeString(jObjMember["Keyword3"]);
                string keyword4 = StringHelper.SafeString(jObjMember["Keyword4"]);
                string keyword5 = StringHelper.SafeString(jObjMember["Keyword5"]);
                string keyword6 = StringHelper.SafeString(jObjMember["Keyword6"]);
                string keyword7 = StringHelper.SafeString(jObjMember["Keyword7"]);

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    commonBiz.UpdateURDetail1Info(userID, personNo1, personNo2, birth, birthType, mobile, telephone, keyword1, keyword2, keyword3, keyword4, keyword5, keyword6, keyword7);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"사용자 정보 수정에 실패하였습니다. :: {result.ResultMessage}";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        // <summary>
        /// 사용자 상세 정보 변경
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string UpdateDetail2UserInfo()
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

                string memberJson = StringHelper.SafeString(jObj["memberJson"].ToString());

                // 다시 파싱
                JObject jObjMember = JObject.Parse(memberJson);

                int userID = StringHelper.SafeInt(jObjMember["UserID"]);
                string fax = StringHelper.SafeString(jObjMember["Fax"]);
                string homePhone = StringHelper.SafeString(jObjMember["HomePhone"]);
                string homePage = StringHelper.SafeString(jObjMember["HomePage"]);
                string themePath = StringHelper.SafeString(jObjMember["ThemePath"]);
                themePath = (String.IsNullOrWhiteSpace(themePath)) ? "11" : themePath;              // HARDCODING
                string zipCode1 = StringHelper.SafeString(jObjMember["ZipCode1"]);
                string address1 = StringHelper.SafeString(jObjMember["Address1"]);
                string detailAddress1 = StringHelper.SafeString(jObjMember["DetailAddress1"]);
                string company = StringHelper.SafeString(jObjMember["Company"]);
                string zipCode2 = StringHelper.SafeString(jObjMember["ZipCode2"]);
                string address2 = StringHelper.SafeString(jObjMember["Address2"]);
                string detailAddress2 = StringHelper.SafeString(jObjMember["DetailAddress2"]);
                

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    commonBiz.UpdateURDetail2Info(userID, fax, homePhone, homePage, StringHelper.SafeInt(themePath), zipCode1, address1, detailAddress1, company, zipCode2, address2, detailAddress2);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"사용자 정보 수정에 실패하였습니다. :: {result.ResultMessage}";
                }
            }
            else
            {
                ResultCode = "FAIL";
                ResultMessage = "IsAjaxRequest가 아님";
            }

            return CreateJsonData();
        }

        // <summary>
        /// 사용자 삭제
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string DeleteUserInfo()
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

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    commonBiz.DeleteURInfo(userID);
                }

                if (result.ResultCode >= 0)
                {
                    return CreateJsonData();
                }
                else
                {
                    ResultCode = "FAIL";
                    ResultMessage = $"사용자 삭제에 실패하였습니다. :: {result.ResultMessage}";
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