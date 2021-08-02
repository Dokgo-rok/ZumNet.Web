using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.ServiceBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Util;
using ZumNet.Framework.Web.Base;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class EventController : ControllerWebBase
    {
        [Authorize]
        public ActionResult Index()
        {
            return View();
        }

        [Authorize]
        public ActionResult Logon()
        {
            return WebView(View());
        }

        [Authorize]
        public ActionResult WriteLog()
        {
            return View();
        }

        [Authorize]
        public ActionResult ViewLog()
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public string SearchConnectLogList()
        {
            if (Request.IsAjaxRequest())
            {
                string eventViewName = StringHelper.SafeString(Request.Form["eventViewName"]);
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumn = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string prevSortColumn = StringHelper.SafeString(Request.Form["prevSortColumn"]);             // 이전 소트 컬럼
                string prevSortType = StringHelper.SafeString(Request.Form["prevSortColumn"]);               // 이전 소트 타입
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
                }

                if (pageCount == 0)
                {
                    pageCount = 20;
                }

                switch (sortColumn)
                {
                    case "0":
                        sortColumn = "UserName";
                        break;
                    case "1":
                        sortColumn = "DeptName";
                        break;
                    case "2":
                        sortColumn = "EventTime";
                        break;
                    case "3":
                        sortColumn = "UserID";
                        break;
                    case "4":
                        sortColumn = "LogonID";
                        break;
                    case "5":
                        sortColumn = "StartTime";
                        break;
                    case "6":
                        sortColumn = "EndTime";
                        break;
                    default:
                        break;
                }

                // 페이지 최초 진입시
                if (String.IsNullOrWhiteSpace(prevSortColumn))
                {
                    sortColumn = "EventTime";
                    sortType = "desc";
                }
                else
                {
                    // sortcolumn이 같지 않으면 페이지를 1로
                    if (String.Compare(sortColumn, prevSortColumn, true) != 0)
                    {
                        pageIndex = 1;
                    }

                    // sortType이 같지 않으면 페이지를 1로
                    if (String.Compare(sortType, prevSortType, true) != 0)
                    {
                        pageIndex = 1;
                    }
                }

                if (String.IsNullOrWhiteSpace(searchColumn) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetEventLogList(eventViewName
                            , pageIndex
                            , pageCount
                            , sortColumn
                            , sortType
                            , searchColumn
                            , searchText
                            , searchStartDate
                            , searchEndDate);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMsg"]);
                    ResultItemFilteredCount = ResultItemCount;
                    ResultPageIndex = pageIndex;
                    ResultSortColumn = sortColumn;
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

        [HttpPost]
        [Authorize]
        public string SearchLogonLogList()
        {
            if (Request.IsAjaxRequest())
            {
                string eventViewName = StringHelper.SafeString(Request.Form["eventViewName"]);
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumn = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string prevSortColumn = StringHelper.SafeString(Request.Form["prevSortColumn"]);             // 이전 소트 컬럼
                string prevSortType = StringHelper.SafeString(Request.Form["prevSortColumn"]);               // 이전 소트 타입
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
                }

                if (pageCount == 0)
                {
                    pageCount = 20;
                }

                switch (sortColumn)
                {
                    case "0":
                        sortColumn = "UserName";
                        break;
                    case "1":
                        sortColumn = "DeptName";
                        break;
                    case "2":
                        sortColumn = "EventTime";
                        break;
                    case "3":
                        sortColumn = "LogonID";
                        break;
                    case "4":
                        sortColumn = "IP";
                        break;
                    default:
                        break;
                }

                // 페이지 최초 진입시
                if (String.IsNullOrWhiteSpace(prevSortColumn))
                {
                    sortColumn = "EventTime";
                    sortType = "desc";
                }
                else
                {
                    // sortcolumn이 같지 않으면 페이지를 1로
                    if (String.Compare(sortColumn, prevSortColumn, true) != 0)
                    {
                        pageIndex = 1;
                    }

                    // sortType이 같지 않으면 페이지를 1로
                    if (String.Compare(sortType, prevSortType, true) != 0)
                    {
                        pageIndex = 1;
                    }
                }

                if (String.IsNullOrWhiteSpace(searchColumn) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetEventLogList(eventViewName
                            , pageIndex
                            , pageCount
                            , sortColumn
                            , sortType
                            , searchColumn
                            , searchText
                            , searchStartDate
                            , searchEndDate);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMsg"]);
                    ResultItemFilteredCount = ResultItemCount;
                    ResultPageIndex = pageIndex;
                    ResultSortColumn = sortColumn;
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

        [HttpPost]
        [Authorize]
        public string SearchDocumentWriteLogList()
        {
            if (Request.IsAjaxRequest())
            {
                string eventViewName = StringHelper.SafeString(Request.Form["eventViewName"]);
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumn = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string prevSortColumn = StringHelper.SafeString(Request.Form["prevSortColumn"]);             // 이전 소트 컬럼
                string prevSortType = StringHelper.SafeString(Request.Form["prevSortColumn"]);               // 이전 소트 타입
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
                }

                if (pageCount == 0)
                {
                    pageCount = 20;
                }

                switch (sortColumn)
                {
                    case "0":
                        sortColumn = "UserName";
                        break;
                    case "1":
                        sortColumn = "DeptName";
                        break;
                    case "2":
                        sortColumn = "EventTime";
                        break;
                    case "3":
                        sortColumn = "UserID";
                        break;
                    case "4":
                        sortColumn = "ActType";
                        break;
                    case "5":
                        sortColumn = "XfAlias";
                        break;
                    case "6":
                        sortColumn = "MessageID";
                        break;
                    case "7":
                        sortColumn = "Subject";
                        break;
                    case "8":
                        sortColumn = "FD_ID";
                        break;
                    case "9":
                        sortColumn = "FDName";
                        break;
                    default:
                        break;
                }

                // 페이지 최초 진입시
                if (String.IsNullOrWhiteSpace(prevSortColumn))
                {
                    sortColumn = "EventTime";
                    sortType = "desc";
                }
                else
                {
                    // sortcolumn이 같지 않으면 페이지를 1로
                    if (String.Compare(sortColumn, prevSortColumn, true) != 0)
                    {
                        pageIndex = 1;
                    }

                    // sortType이 같지 않으면 페이지를 1로
                    if (String.Compare(sortType, prevSortType, true) != 0)
                    {
                        pageIndex = 1;
                    }
                }

                if (String.IsNullOrWhiteSpace(searchColumn) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetEventLogList(eventViewName
                            , pageIndex
                            , pageCount
                            , sortColumn
                            , sortType
                            , searchColumn
                            , searchText
                            , searchStartDate
                            , searchEndDate);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMsg"]);
                    ResultItemFilteredCount = ResultItemCount;
                    ResultPageIndex = pageIndex;
                    ResultSortColumn = sortColumn;
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

        [HttpPost]
        [Authorize]
        public string SearchDocumentViewLogList()
        {
            if (Request.IsAjaxRequest())
            {
                string eventViewName = StringHelper.SafeString(Request.Form["eventViewName"]);
                int pageIndex = StringHelper.SafeInt(Request.Form["draw"]);
                int pageCount = StringHelper.SafeInt(Request.Form["length"]);
                string sortColumn = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string prevSortColumn = StringHelper.SafeString(Request.Form["prevSortColumn"]);             // 이전 소트 컬럼
                string prevSortType = StringHelper.SafeString(Request.Form["prevSortColumn"]);               // 이전 소트 타입
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
                }

                if (pageCount == 0)
                {
                    pageCount = 20;
                }

                switch (sortColumn)
                {
                    case "0":
                        sortColumn = "UserName";
                        break;
                    case "1":
                        sortColumn = "DeptName";
                        break;
                    case "2":
                        sortColumn = "EventTime";
                        break;
                    case "3":
                        sortColumn = "UserID";
                        break;
                    case "4":
                        sortColumn = "XfAlias";
                        break;
                    case "5":
                        sortColumn = "MessageID";
                        break;
                    case "6":
                        sortColumn = "Subject";
                        break;
                    case "7":
                        sortColumn = "FD_ID";
                        break;
                    case "8":
                        sortColumn = "FDName";
                        break;
                    default:
                        break;
                }

                // 페이지 최초 진입시
                if (String.IsNullOrWhiteSpace(prevSortColumn))
                {
                    sortColumn = "EventTime";
                    sortType = "desc";
                }
                else
                {
                    // sortcolumn이 같지 않으면 페이지를 1로
                    if (String.Compare(sortColumn, prevSortColumn, true) != 0)
                    {
                        pageIndex = 1;
                    }

                    // sortType이 같지 않으면 페이지를 1로
                    if (String.Compare(sortType, prevSortType, true) != 0)
                    {
                        pageIndex = 1;
                    }
                }

                if (String.IsNullOrWhiteSpace(searchColumn) && !String.IsNullOrWhiteSpace(searchText))
                {
                    searchText = "";
                }

                ServiceResult result = new ServiceResult();

                using (CommonBiz commonBiz = new CommonBiz())
                {
                    result = commonBiz.GetEventLogList(eventViewName
                            , pageIndex
                            , pageCount
                            , sortColumn
                            , sortType
                            , searchColumn
                            , searchText
                            , searchStartDate
                            , searchEndDate);
                }

                if (result.ResultCode == 0)
                {
                    ResultItemCount = StringHelper.SafeInt(result.ResultDataDetail["totalMsg"]);
                    ResultItemFilteredCount = ResultItemCount;
                    ResultPageIndex = pageIndex;
                    ResultSortColumn = sortColumn;
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
    }
}