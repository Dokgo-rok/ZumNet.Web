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
        #region [ /Woa/Event ]

        [Authorize]
        public ActionResult Index()
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
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
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

        #region [ /Woa/Event/Logon ]

        [Authorize]
        public ActionResult Logon()
        {
            return WebView(View());
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
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
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

        #region [ /Woa/Event/WriteLog ]

        [Authorize]
        public ActionResult WriteLog()
        {
            return View();
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
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
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

        #region [ /Woa/Event/ViewLog ]

        [Authorize]
        public ActionResult ViewLog()
        {
            return View();
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
                string sortColumnIndex = StringHelper.SafeString(Request.Form["order[0][column]"]);
                string sortColumn = StringHelper.SafeString(Request.Form[$"columns[{sortColumnIndex}][data]"]);
                string sortType = StringHelper.SafeString(Request.Form["order[0][dir]"]);
                string searchColumn = StringHelper.SafeString(Request.Form["searchColumn"]);
                string searchText = StringHelper.SafeString(Request.Form["searchText"]);
                string searchStartDate = StringHelper.SafeString(Request.Form["searchStartDate"]);
                string searchEndDate = StringHelper.SafeString(Request.Form["searchEndDate"]);

                if (pageIndex == 0)
                {
                    pageIndex = 1;
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