using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.TnC.Controllers
{
    public class BookingController : Controller
    {
        #region [메인, 목록]
        // GET: TnC/Booking
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath;
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //초기 설정 가져오기
            rt = Bc.CtrlHandler.BookingInit(this);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (rt == "")
            {
                using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                {
                    svcRt = schBiz.GetBookingClass(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(ViewBag.R.ct.Value)
                                , Convert.ToInt32(ViewBag.R.fdid.Value).ToString(), Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString());

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.ResClass = svcRt.ResultDataRowCollection;
                        ViewBag.ResList = svcRt.ResultDataDetail["Resources"];
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }

                    int startDayOfWeek = Convert.ToInt32(DateTime.Today.DayOfWeek.ToString("d"));   // 시작일의 요일 배열 : 0 - 일요일, 1 - 월요일...
                    int endDayOfWeek = 7 - startDayOfWeek - 1;

                    DateTime dtStartTemp = DateTime.Today.AddDays(-startDayOfWeek); //Convert.ToDateTime("2020-04-05");
                    DateTime dtEndTemp = DateTime.Today.AddDays(endDayOfWeek); //Convert.ToDateTime("2020-04-11");

                    svcRt = schBiz.GetSchedulePartsList("0", Convert.ToInt32(Session["URID"]), "FD", 0, "", "", "PeriodFrom", dtStartTemp.ToShortDateString(), dtEndTemp.ToShortDateString());
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.BoardList = svcRt.ResultDataSet.Tables[0];
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                }
            }

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult List(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath;
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //초기 설정 가져오기
            rt = Bc.CtrlHandler.BookingInit(this);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //첫 화면 데이터 가져오기
            DateTime dtView = StringHelper.SafeDateTime(ViewBag.R.lv["tgt"].ToString());
            ViewBag.R.lv["tgt"] = dtView.ToString("yyyy-MM-dd");

            DateTime dtStartTemp = new DateTime(dtView.Year, dtView.Month, 1);
            DateTime dtEndTemp = new DateTime(dtView.Year, dtView.Month, DateTime.DaysInMonth(dtView.Year, dtView.Month));

            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "MyList"); //기본 내 예약현황
            string cmd = ViewBag.R["ft"].ToString() == "MyList" ? "0" : "1";
            int iUserID = ViewBag.R["ft"].ToString() == "MyList" ? Convert.ToInt32(Session["URID"]) : 0;

            using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
            {
                svcRt = schBiz.GetSchedulePartsList(cmd, iUserID, "FD", 0, "", "", "PeriodFrom", dtStartTemp.ToShortDateString(), dtEndTemp.ToShortDateString());
            }
                
            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.Mode = "";
                ViewBag.BoardList = svcRt.ResultDataSet.Tables[0];
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string List()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (rt == "")
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    sPos = "200";
                    rt = Resources.Global.Auth_InvalidPath;
                    if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0") return "[" + sPos + "] " + rt;

                    //초기 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.BookingInit(this);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    DateTime dtView = Convert.ToDateTime(ViewBag.R.lv["tgt"].ToString());
                    DateTime dtStartTemp = new DateTime(dtView.Year, dtView.Month, 1);
                    DateTime dtEndTemp = new DateTime(dtView.Year, dtView.Month, DateTime.DaysInMonth(dtView.Year, dtView.Month));

                    string cmd = ViewBag.R["ft"].ToString() == "MyList" ? "0" : "1";
                    int iUserID = ViewBag.R["ft"].ToString() == "MyList" ? Convert.ToInt32(Session["URID"]) : 0;

                    using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                    {
                        svcRt = schBiz.GetSchedulePartsList(cmd, iUserID, "FD", 0, "", "", "PeriodFrom", dtStartTemp.ToShortDateString(), dtEndTemp.ToShortDateString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";
                        ViewBag.Mode = "ajax";
                        ViewBag.BoardList = svcRt.ResultDataSet.Tables[0];

                        string sDesc = (dtView.Year == DateTime.Now.Year ? "" : dtView.Year.ToString() + "년 ") + dtView.Month.ToString() + "월";

                        sPos = "510";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + ViewBag.R["ft"].ToString(), ViewBag)
                            + jPost["lv"]["boundary"].ToString()
                            + sDesc;
                    }
                    else
                    {
                        rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }

            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ResourceSchedule()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["cls"].ToString() == "" || jPost["dt"].ToString() == "" || jPost["res"] == null) return "필수값 누락!";

                    ViewBag.JPost = jPost;

                    rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ResourceSchedule", ViewBag);
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [이벤트]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string EventView()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["dt"].ToString() == "") return "필수값 누락!";

                    int iMessageId = StringHelper.SafeInt(jPost["mi"]);
                    if (jPost["M"].ToString() == "new")
                    {
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        ZumNet.Framework.Core.ServiceResult svcRt = null;
                        using (ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz())
                        {
                            svcRt = todo.GetToDoView("", Convert.ToInt32(Session["DNID"]), iMessageId, jPost["dt"].ToString());
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.WorkEvent = svcRt.ResultDataSet;
                            ViewBag.JPost = jPost;
                        }
                        else
                        {
                            //에러페이지
                            rt = svcRt.ResultMessage;
                        }
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_EventView", ViewBag);
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion
    }
}