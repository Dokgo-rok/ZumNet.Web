using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class AppController : ControllerWebBase
    {
        // GET: WoA/App
        public ActionResult Index()
        {
            return View();
        }

        // GET: WoA/App/Class
        public ActionResult Class()
        {
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

                using (EAProcessBiz eaProcessBiz = new EAProcessBiz())
                {
                    result = eaProcessBiz.SelectEAFormClass(domainID);
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

                using (EAProcessBiz eaProcessBiz = new EAProcessBiz())
                {
                    result = eaProcessBiz.HandleEAFormClass(command, classid, domainid, formname, formseqno);
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
    }
}