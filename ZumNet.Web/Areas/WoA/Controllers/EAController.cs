using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class EAController : ControllerWebBase
    {
        #region [ /Woa/EA/Index ]

        // GET: WoA/EA
        public ActionResult Index()
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
                        treeInfo.state.Add("opened", true);
                        treeInfo.etc = new Dictionary<string, string>();
                        treeInfo.etc.Add("reserved1", StringHelper.SafeString(dr["Reserved1"].ToString()));
                        treeInfo.text = StringHelper.SafeString(dr["DisplayName"].ToString());

                        listTree.Add(treeInfo);
                    }
                }
            }

            ViewData["deptlist"] = JsonConvert.SerializeObject(listTree);

            using (CommonBiz commonBiz = new CommonBiz())
            {
                ServiceResult resultMember = commonBiz.SearchDomainUsers(domainID.ToString(), "", "D", 0, 0, "DisplayName", "ASC", "", "Y");

                if (resultMember.ResultCode == 0 && resultMember.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["memberlist"] = JsonConvert.SerializeObject(resultMember.ResultDataTable);
                }
            }

            using (AppWorks appWk = new AppWorks())
            {
                ServiceResult resulRcv = appWk.SelectReceiverManager("rcvmanager");

                if (resulRcv.ResultCode == 0 && resulRcv.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["rcvmanagerlist"] = JsonConvert.SerializeObject(resulRcv.ResultDataTable);
                }
            }

            return View();
        }

        /// <summary>
        /// 문서 수신 정책 변경 - 부서
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string ChangeGroupPolicy()
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

                int groupID = StringHelper.SafeInt(jPost["groupID"].ToString());
                string reserved1 = StringHelper.SafeString(jPost["reserved1"].ToString());
                
                ServiceResult result = new ServiceResult();

                using (AppWorks appWk = new AppWorks())
                {
                    result = appWk.ChangeReceiverDeptPolicy(groupID, reserved1);
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

        /// <summary>
        /// 문서 수신 정책 변경 - 담당자
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string ChangeMemberPolicy()
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

                int objID = StringHelper.SafeInt(jPost["objID"].ToString());
                string objType = "GR";
                string targetIDs = StringHelper.SafeString(jPost["targetIDs"].ToString());
                string targetType = "UR";
                string auAlias = "rcvmanager";

                ServiceResult result = new ServiceResult();

                using (AppWorks appWk = new AppWorks())
                {
                    result = appWk.HandleRcvAuthorityManager(objID, objType, targetIDs, targetType, auAlias, "");
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

        #region [ /Woa/EA/Share ]

        // GET: WoA/EA
        public ActionResult Share()
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
                        treeInfo.state.Add("opened", true);
                        treeInfo.etc = new Dictionary<string, string>();
                        treeInfo.etc.Add("reserved1", StringHelper.SafeString(dr["Reserved1"].ToString()));
                        treeInfo.text = StringHelper.SafeString(dr["DisplayName"].ToString());

                        listTree.Add(treeInfo);
                    }
                }
            }

            ViewData["deptlist"] = JsonConvert.SerializeObject(listTree);

            using (CommonBiz commonBiz = new CommonBiz())
            {
                ServiceResult resultMember = commonBiz.SearchDomainUsers(domainID.ToString(), "", "D", 0, 0, "DisplayName", "ASC", "", "Y");

                if (resultMember.ResultCode == 0 && resultMember.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["memberlist"] = JsonConvert.SerializeObject(resultMember.ResultDataTable);
                }
            }

            using (AppWorks appWk = new AppWorks())
            {
                ServiceResult resultFolder = appWk.SelectEAFolderView(0);

                if (resultFolder.ResultCode == 0 && resultFolder.ResultDataTable?.Rows?.Count > 0)
                {
                    ViewData["folderviewjson"] = JsonConvert.SerializeObject(resultFolder.ResultDataTable);
                }
            }

            return View(result.ResultDataSet.Tables[1]);
        }

        /// <summary>
        /// 부서 문서함 처리
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Authorize]
        public string saveEAFolderView()
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

                int groupID = StringHelper.SafeInt(jPost["groupID"].ToString());
                string targetIDs = StringHelper.SafeString(jPost["targetIDs"].ToString());
                string registrant = $"관리툴 - {Session["URName"].ToString()}";

                ServiceResult result = new ServiceResult();

                using (AppWorks appWk = new AppWorks())
                {
                    result = appWk.HandleEAFolderView(groupID, targetIDs, "", registrant); ;
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

        #region [ /Woa/EA/Code ]

        // GET: WoA/EA
        public ActionResult Code()
        {
            ServiceResult result = new ServiceResult();

            DataSet ds = new DataSet();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                // BizRole 조회
                result = commonBiz.SelectCodeDescription("ea", "bizrole", "");
                result.ResultDataTable.TableName = "dtBizRole";

                ds.Tables.Add(result.ResultDataTable.Copy());

                // ActRole 조회
                result = commonBiz.SelectCodeDescription("ea", "actrole", "");
                result.ResultDataTable.TableName = "dtActRole";

                ds.Tables.Add(result.ResultDataTable.Copy());

                // 결재 진행 상태값 조회
                result = commonBiz.SelectCodeDescription("ea", "docstatus", "");
                result.ResultDataTable.TableName = "dtDocStatusRole";

                ds.Tables.Add(result.ResultDataTable.Copy());
            }

            return View(ds);
        }

        #endregion

        #region [ /Woa/EA/External ]

        // GET: WoA/EA
        public ActionResult External()
        {
            ServiceResult result = new ServiceResult();

            using (CommonBiz commonBiz = new CommonBiz())
            {
                // BizRole 조회
                result = commonBiz.SelectCodeDescription("ea", "externalform", "");
            }

            return View(result.ResultDataTable);
        }

        #endregion

        #region [ /Woa/EA/Remark ]

        // GET: WoA/EA
        public ActionResult Remark()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SelectRemarkInfo()
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

                string key1 = "eaxf";
                string key2 = StringHelper.SafeString(jPost["key2"].ToString());

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.SelectCodeDescription(key1, key2, "");
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
    }
}