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

                    DateTime dtStartTemp = Convert.ToDateTime("2020-04-05");// DateTime.Today.AddDays(-startDayOfWeek);
                    DateTime dtEndTemp = Convert.ToDateTime("2020-04-11");//DateTime.Today.AddDays(endDayOfWeek);

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

        #region []
        #endregion
    }
}