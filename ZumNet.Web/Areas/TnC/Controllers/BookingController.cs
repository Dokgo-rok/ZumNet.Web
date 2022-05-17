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
            rt = Bc.CtrlHandler.BookingInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (rt == "")
            {
                int iTarget = Convert.ToInt32(ViewBag.R.fdid);

                using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                {
                    svcRt = schBiz.GetBookingClass(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(ViewBag.R.ct.Value)
                                , ViewBag.R.opnode.ToString(), Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString());

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

                    if (iTarget == 0)
                    {
                        //자원예약 첫 화면 경우
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
            rt = Bc.CtrlHandler.BookingInit(this, false);
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
                    rt = Bc.CtrlHandler.BookingInit(this, false);
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ResourceList()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ct"].ToString() == "" || jPost["operator"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                    {
                        svcRt = schBiz.GetBookingClass(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(jPost["ct"])
                                    , "", Convert.ToInt32(Session["URID"]), jPost["operator"].ToString());

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.ResClass = svcRt.ResultDataRowCollection;
                            ViewBag.ResList = svcRt.ResultDataDetail["Resources"];

                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ResourceList", ViewBag);
                        }
                        else
                        {
                            rt = svcRt.ResultMessage;
                        }
                    }
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ResourceInfo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["fdid"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                    {
                        svcRt = comBiz.GetFolderAttribute(0, 0, Convert.ToInt32(jPost["fdid"]));

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.ResInfo = svcRt.ResultDataRow;

                            svcRt = comBiz.GetObjectACL(Convert.ToInt32(Session["DNID"]), svcRt.ResultDataRow["Inherited"].ToString(), Convert.ToInt32(jPost["fdid"]), "FD", "0");

                            if (svcRt != null && svcRt.ResultCode == 0)
                            {
                                ViewBag.ResAcl = svcRt.ResultDataSet;
                                ViewBag.Mode = jPost.ContainsKey("M") ? jPost["M"].ToString() : "popover"; //modal or popover
                                ViewBag.Boundary = jPost["boundary"].ToString();

                                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ResourceInfo", ViewBag);
                            }
                            else rt = svcRt.ResultMessage;
                        }
                        else rt = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [달력, 현황]
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Calendar(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath;
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0" || ViewBag.R.fdid == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //초기 설정 가져오기
            rt = Bc.CtrlHandler.BookingInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //첫 화면 데이터 가져오기
            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "Request"); //기본 목록보기

            DateTime dtView = Convert.ToDateTime(ViewBag.R.lv["tgt"].ToString());
            DateTime dtStartTemp = new DateTime(dtView.Year, dtView.Month, 1);
            DateTime dtEndTemp = new DateTime(dtView.Year, dtView.Month, DateTime.DaysInMonth(dtView.Year, dtView.Month));

            using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
            {
                if (ViewBag.R["ft"].ToString() == "Request")
                {
                    svcRt = schBiz.GetSchedulePartsList("1", 0, ViewBag.R.ot.ToString(), Convert.ToInt32(ViewBag.R.fdid.Value), "", "", "PeriodFrom", dtStartTemp.ToShortDateString(), dtEndTemp.ToShortDateString());
                }
                else
                {
                    string cmd = ViewBag.R["ft"].ToString() == "Month" ? "M" : ViewBag.R["ft"].ToString() == "Week" ? "W" : "D";
                    string sScheduleType = StringHelper.SafeString(ViewBag.R.lv["sort"].ToString()); //nn, ap, cf, ev,va, an, tr ...
                    svcRt = schBiz.GetScheduleSeacrhInfomation("", ViewBag.R.ot.ToString(), Convert.ToInt32(ViewBag.R.fdid.Value), 99, sScheduleType, cmd, ViewBag.R.lv["tgt"].ToString(), "", "");
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.Mode = "";
                ViewBag.BoardList = svcRt.ResultDataSet;
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
        public string Calendar()
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
                    rt = Bc.CtrlHandler.BookingInit(this, true);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    int iTarget = Convert.ToInt32(jPost["fdid"]);
                    string formTable = jPost["ft"].ToString();

                    DateTime dtView = Convert.ToDateTime(jPost["lv"]["tgt"].ToString());
                    DateTime dtStartTemp = new DateTime(dtView.Year, dtView.Month, 1);
                    DateTime dtEndTemp = new DateTime(dtView.Year, dtView.Month, DateTime.DaysInMonth(dtView.Year, dtView.Month));

                    using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                    {
                        if (ViewBag.R["ft"].ToString() == "Request")
                        {
                            sPos = "500";
                            svcRt = schBiz.GetSchedulePartsList("1", 0, jPost["ot"].ToString(), iTarget, "", "", "PeriodFrom", dtStartTemp.ToShortDateString(), dtEndTemp.ToShortDateString());
                        }
                        else
                        {
                            sPos = "510";
                            string cmd = formTable == "Month" ? "M" : formTable == "Week" ? "W" : "D";
                            string sScheduleType = StringHelper.SafeString(jPost["lv"]["sort"].ToString()); //nn, ap, cf, ev,va, an, tr ...
                            svcRt = schBiz.GetScheduleSeacrhInfomation("", jPost["ot"].ToString(), iTarget, 99, sScheduleType, cmd, dtView.ToString("yyyy-MM-dd"), "", "");
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "520";
                        ViewBag.Mode = "ajax";
                        ViewBag.BoardList = svcRt.ResultDataSet;

                        string sDesc = "";

                        if (ViewBag.R.ft.ToString() == "Day")
                        {
                            sDesc = (dtView.Year == DateTime.Now.Year ? "" : dtView.Year.ToString() + "년 ") + dtView.Month.ToString() + "월 " + dtView.Day.ToString() + "일";
                        }
                        else if (ViewBag.R.ft.ToString() == "Week")
                        {
                            sDesc = (dtView.Year == DateTime.Now.Year ? "" : dtView.Year.ToString() + "년 ") + dtView.Month.ToString() + "월" + " " + dtView.Day.ToString()
                                     + "일 ~ " + (dtView.Month == dtView.AddDays(6).Month ? "" : dtView.AddDays(6).Month.ToString() + "월 ") + dtView.AddDays(6).Day.ToString() + "일";
                        }
                        else //Month, Request
                        {
                            sDesc = (dtView.Year == DateTime.Now.Year ? "" : dtView.Year.ToString() + "년 ") + dtView.Month.ToString() + "월";
                        }

                        sPos = "530";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
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
        #endregion

        #region [이벤트 - 예약, 일정]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Write()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    //초기 설정 가져오기
                    sPos = "200";
                    rt = Bc.CtrlHandler.BookingInit(this, true);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    if (ViewBag.R.current["operator"].ToString() == "N" && !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "W"))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "300";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    rt = FormHandler.BindScheduleToJson(this, svcRt);

                    if (rt != "")
                    {
                        rt = "[" + sPos + "] " + rt;
                    }
                    else
                    {
                        sPos = "400";
                        jPost["app"]["dnid"] = Session["DNID"].ToString();
                        jPost["app"]["ot"] = jPost["ot"].ToString() == "" || jPost["ot"].ToString() == "FD" ? "UR" : jPost["ot"].ToString();
                        jPost["app"]["otid"] = jPost["ot"].ToString() == "FD" || Convert.ToInt32(jPost["fdid"]) == 0 ? Session["URID"].ToString() : jPost["fdid"].ToString();

                        sPos = "410";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Write", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + Newtonsoft.Json.JsonConvert.SerializeObject(jPost["app"]);
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
        public string Read()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    //초기 설정 가져오기
                    sPos = "200";
                    rt = Bc.CtrlHandler.BookingInit(this, true);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    if (ViewBag.R.current["operator"].ToString() == "N" && !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R"))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "300";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using(ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                    {
                        svcRt = schBiz.GetScheduleInfomation(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(jPost["appid"]));
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "310";
                        rt = FormHandler.BindScheduleToJson(this, svcRt);

                        if (rt != "")
                        {
                            rt = "[" + sPos + "] " + rt;
                        }
                        else
                        {
                            sPos = "400";
                            jPost["app"]["dnid"] = Session["DNID"].ToString();
                            jPost["app"]["ot"] = jPost["ot"].ToString() == "" || jPost["ot"].ToString() == "FD" ? "UR" : jPost["ot"].ToString();
                            jPost["app"]["otid"] = jPost["ot"].ToString() == "FD" || Convert.ToInt32(jPost["fdid"]) == 0 ? Session["URID"].ToString() : jPost["fdid"].ToString();

                            sPos = "410";
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Read", ViewBag)
                                    + jPost["lv"]["boundary"].ToString()
                                    + Newtonsoft.Json.JsonConvert.SerializeObject(jPost["app"]);
                        }
                    }
                    else
                    {
                        //에러페이지
                        sPos = "320";
                        rt = svcRt.ResultMessage;
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
        public string Edit()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    //초기 설정 가져오기
                    sPos = "200";
                    rt = Bc.CtrlHandler.BookingInit(this, true);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    if (ViewBag.R.current["operator"].ToString() == "N" && !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "W"))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "300";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                    {
                        svcRt = schBiz.GetScheduleInfomation(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(jPost["appid"]));
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "310";
                        rt = FormHandler.BindScheduleToJson(this, svcRt);

                        if (rt != "")
                        {
                            rt = "[" + sPos + "] " + rt;
                        }
                        else
                        {
                            sPos = "400";
                            jPost["app"]["dnid"] = Session["DNID"].ToString();
                            jPost["app"]["ot"] = jPost["ot"].ToString() == "" || jPost["ot"].ToString() == "FD" ? "UR" : jPost["ot"].ToString();
                            jPost["app"]["otid"] = jPost["ot"].ToString() == "FD" || Convert.ToInt32(jPost["fdid"]) == 0 ? Session["URID"].ToString() : jPost["fdid"].ToString();

                            sPos = "410";
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Edit", ViewBag)
                                    + jPost["lv"]["boundary"].ToString()
                                    + Newtonsoft.Json.JsonConvert.SerializeObject(jPost["app"]);
                        }
                    }
                    else
                    {
                        //에러페이지
                        sPos = "320";
                        rt = svcRt.ResultMessage;
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
        public string EventSave()
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["mode"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), jPost["xfalias"].ToString(), (JArray)jPost["attachlist"], null, "");
                    if (svcRt.ResultCode != 0)
                    {
                        rt = "[" + sPos + "] " + svcRt.ResultMessage;
                    }
                    else
                    {
                        sPos = "210";
                        jPost["attachlist"] = (JArray)svcRt.ResultDataDetail["FileInfo"];

                        sPos = "220";
                        string fileInfo = attachHdr.ConvertFileInfoToXml((JArray)jPost["attachlist"]);

                        sPos = "300";
                        using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                        {
                            svcRt = schBiz.SaveSchedule(jPost, Convert.ToInt32(Session["DNID"]), Convert.ToInt32(Session["URID"]), Session["DeptName"].ToString(), Convert.ToInt32(Session["DeptID"]), fileInfo);
                        }

                        if (svcRt != null && svcRt.ResultCode == 0) rt = "OK" + "저장했습니다!";
                        else rt = "[" + sPos + "] " + svcRt.ResultMessage;
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
        public string EventDelete()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || StringHelper.SafeInt(jPost["mi"]) == 0) return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz())
                    {
                        svcRt = todo.DeleteToDo("U", jPost["ot"].ToString(), StringHelper.SafeInt(jPost["otid"]), Convert.ToInt32(jPost["mi"])
                                            , Convert.ToInt32(Session["URID"]), jPost["opt"].ToString(), jPost["dt"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        if (svcRt.ResultDataString == "N") rt = "해당 일정은 삭제할 수 없는 상태입니다!";
                        else rt = "OK" + "삭제했습니다!";
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                    }
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