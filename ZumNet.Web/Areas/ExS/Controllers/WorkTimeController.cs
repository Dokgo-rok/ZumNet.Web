using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class WorkTimeController : Controller
    {
        #region [메뉴별 목록]
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index(string Qi)
        {
            //string rt = Bc.CtrlHandler.PageInit(this, false);

            //if (Qi == null || Qi.Length == 0) Qi = Server.UrlEncode("{ct:\"303\",ctalias:\"worktime\",ttl:\"근무현황\",opnode:\"\"}");

            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ViewBag.R.ct == null || ViewBag.R.ct == "0" || ViewBag.R.ft == "")
            {
                ViewBag.R["ct"] = "303";
                ViewBag.R["ctalias"] = "worktime";
                ViewBag.R["ft"] = "PersonStatus";
                ViewBag.R["ttl"] = "근무현황";
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);

            //권한 및 월 기준시간 가져오기
            rt = Bc.CtrlHandler.WorkTimeInit(this, iCategoryId);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (((ViewBag.R.ft.ToString().ToLower() == "memberplan"|| ViewBag.R.ft.ToString().ToLower() == "memberstatus"|| ViewBag.R.ft.ToString().ToLower() == "memberrequest") && ViewBag.R["current"]["chief"].ToString() != "Y")
                || ((ViewBag.R.ft.ToString().ToLower() == "statusmgr" || ViewBag.R.ft.ToString().ToLower() == "requestmgr" || ViewBag.R.ft.ToString().ToLower() == "ledgermgr" || ViewBag.R.ft.ToString().ToLower() == "worktimemgr") && ViewBag.R["current"]["operator"].ToString() != "Y"))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ViewBag.R.ft.ToString().ToLower() == "worktimemgr")
            {
                using(ZumNet.BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = comBiz.SelectCodeDescription("system", "worktime", "");
                }
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wt = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    if (ViewBag.R.ft.ToString().ToLower() == "workplan")
                    {
                        svcRt = wt.GetWorkTimePlan("P", Convert.ToInt32(Session["URID"]), ViewBag.R.current.date.ToString());
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "memberplan")
                    {
                        svcRt = wt.GetWorkTimePlan("D", Convert.ToInt32(Session["URID"]), ViewBag.R.current.date.ToString());
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "personstatus")
                    {
                        svcRt = wt.GetWorkTimeDaily("P", Convert.ToInt32(Session["URID"]), ViewBag.R.current.date.ToString(), "", "", "", "");
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "memberstatus")
                    {
                        svcRt = wt.GetWorkTimeDaily("D", Convert.ToInt32(Session["URID"]), ViewBag.R.current.date.ToString(), "", "", "", "");
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "statusmgr")
                    {
                        svcRt = wt.GetWorkTimeDaily("A", 0, ViewBag.R.current.date.ToString(), "", "", "O", ""); //성명+부서
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "personrequest")
                    {
                        svcRt = wt.GetWorkTimeRequest("P", Convert.ToInt32(Session["URID"]), "go", DateTime.Now.Year.ToString());
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "memberrequest")
                    {
                        svcRt = wt.GetWorkTimeRequest("D", Convert.ToInt32(Session["URID"]), "do", DateTime.Now.Year.ToString());
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "requestmgr")
                    {
                        svcRt = wt.GetWorkTimeRequest("A", 0, "do", DateTime.Now.Year.ToString());
                    }
                    else if (ViewBag.R.ft.ToString().ToLower() == "ledgermgr")
                    {
                        svcRt = wt.GetWorkTimeLedger("O", ViewBag.R.current.date.ToString(), 0, "", "", "", "O", ""); //성명+부서
                    }
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                if (ViewBag.R.ft.ToString().ToLower() == "workplan" || ViewBag.R.ft.ToString().ToLower() == "statusmgr")
                {
                    ViewBag.Holiday = svcRt.ResultDataRowCollection;
                }
                else if (ViewBag.R.ft.ToString().ToLower() == "memberplan" || ViewBag.R.ft.ToString().ToLower() == "memberstatus")
                {
                    ViewBag.Member = svcRt.ResultDataDetail["Member"];
                    ViewBag.Holiday = svcRt.ResultDataRowCollection;
                }
                else if (ViewBag.R.ft.ToString().ToLower() == "memberrequest")
                {
                    ViewBag.Member = svcRt.ResultDataDetail["Member"];
                }
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
        public string Index()
        {
            string sPos = "";
            string rt = Bc.CtrlHandler.AjaxInit(this);

            if (rt == "")
            {
                try
                {
                    sPos = "100";
                    JObject jPost = ViewBag.R;

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);

                    //권한 및 월 기준시간 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.WorkTimeInit(this, iCategoryId);
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    if ((jPost["ft"].ToString().ToLower() == "memberplan" || jPost["ft"].ToString().ToLower() == "memberstatus" || jPost["ft"].ToString().ToLower() == "memberrequest") && jPost["current"]["chief"].ToString() != "Y")
                    {
                        return Resources.Global.Auth_NoPermission;
                    }

                    sPos = "400";
                    if (ViewBag.R.ft.ToString().ToLower() == "worktimemgr")
                    {
                        using (ZumNet.BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                        {
                            svcRt = comBiz.SelectCodeDescription("system", "worktime", "");
                        }
                    }
                    else
                    {
                        using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wt = new BSL.ServiceBiz.WorkTimeBiz())
                        {
                            if (ViewBag.R.ft.ToString().ToLower() == "workplan")
                            {
                                svcRt = wt.GetWorkTimePlan("P", Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "memberplan")
                            {
                                svcRt = wt.GetWorkTimePlan("D", Convert.ToInt32(Session["URID"]), jPost["lv"]["start"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "personstatus")
                            {
                                svcRt = wt.GetWorkTimeDaily("P", Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString(), "", "", "", "");
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "memberstatus")
                            {
                                svcRt = wt.GetWorkTimeDaily("D", Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString(), "", "", "", "");
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "statusmgr")
                            {
                                svcRt = wt.GetWorkTimeDaily("A", 0, jPost["lv"]["start"].ToString(), jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "personrequest")
                            {
                                svcRt = wt.GetWorkTimeRequest("P", Convert.ToInt32(jPost["lv"]["tgt"]), jPost["opnode"].ToString(), jPost["lv"]["start"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "memberrequest")
                            {
                                svcRt = wt.GetWorkTimeRequest("D", Convert.ToInt32(jPost["lv"]["tgt"]), jPost["opnode"].ToString(), jPost["lv"]["start"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "requestmgr")
                            {
                                svcRt = wt.GetWorkTimeRequest("A", 0, jPost["opnode"].ToString(), jPost["lv"]["start"].ToString());
                            }
                            else if (ViewBag.R.ft.ToString().ToLower() == "ledgermgr")
                            {
                                svcRt = wt.GetWorkTimeLedger("O", jPost["lv"]["start"].ToString(), 0, "", jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString()); //성명+부서
                            }
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "410";
                        if (jPost["ft"].ToString().ToLower() == "workplan" || jPost["ft"].ToString().ToLower() == "statusmgr")
                        {
                            ViewBag.Holiday = svcRt.ResultDataRowCollection;
                        }
                        else if (jPost["ft"].ToString().ToLower() == "memberplan" || jPost["ft"].ToString().ToLower() == "memberstatus")
                        {
                            ViewBag.Member = svcRt.ResultDataDetail["Member"];
                            ViewBag.Holiday = svcRt.ResultDataRowCollection;
                        }
                        else if (jPost["ft"].ToString().ToLower() == "memberrequest")
                        {
                            ViewBag.Member = svcRt.ResultDataDetail["Member"];
                        }
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.Mode = ViewBag.R.mode.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + ViewBag.R.ft.ToString(), ViewBag);
                    }
                    else
                    {
                        //에러페이지
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
        public string PersonStatus()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["tgt"].ToString() == "" || jPost["vd"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wt = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wt.GetWorkTimeDaily("P", Convert.ToInt32(jPost["tgt"]), jPost["vd"].ToString(), "", "", "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.Mode = jPost["M"].ToString();
                        ViewBag.Month = Convert.ToDateTime(jPost["vd"]).Month.ToString();
                        ViewBag.ViewPerson = jPost["dn"].ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_PersonStatus", ViewBag);
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }
                }
                catch(Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [근무계획]
        /// <summary>
        /// 근무계획 저장, 승인요청
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SavePlan()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    string sStatus = "";

                    if (jPost == null || jPost.Count == 0 || jPost["mode"].ToString() == "") return "필수값 누락!";

                    if (jPost["mode"].ToString() == "request") sStatus = "1";
                    else sStatus = "0";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.InsertWorkTimePlan(Convert.ToInt32(Session["URID"]), Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"])
                                                , Session["DeptName"].ToString(), Session["Grade1"].ToString(), sStatus, (JArray)jPost["sub"]);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK";
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

        /// <summary>
        /// 근무계획 저장, 승인요청
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DoPlan()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    //string sStatus = "";

                    if (jPost == null || jPost.Count == 0 || jPost["mode"].ToString() == "") return "필수값 누락!";

                    //if (jPost["mode"].ToString() == "confirm") sStatus = "1";
                    //else sStatus = "8";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.SetWorkTimePlan(Convert.ToInt32(Session["URID"]), Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"])
                                                    , Session["DeptName"].ToString(), Session["Grade1"].ToString(), (JArray)jPost["sub"]);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK";
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

        #region [근무기록]
        /// <summary>
        /// 근무상태 팝업
        /// </summary>
        /// <returns></returns>
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

                    if (jPost == null || jPost.Count == 0 || jPost["ur"].ToString() == "" || jPost["wd"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.CheckWorkTimeStatus("V", Convert.ToInt32(jPost["ur"]), jPost["wd"].ToString(), 0, "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.WorkEvent = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;
                        ViewBag.Error = "";
                    }
                    else
                    {
                        //에러페이지
                        ViewBag.Error = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    ViewBag.Error = ex.Message;
                }

                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_EventView", ViewBag);
            }
            return rt;
        }

        /// <summary>
        /// 근무조정요청 팝업
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string EventRequest()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["ur"].ToString() == "" || jPost["wd"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.CheckWorkTimeStatus("R", Convert.ToInt32(jPost["ur"]), jPost["wd"].ToString(), StringHelper.SafeInt(jPost["req"]), "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.WorkEvent = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;
                        ViewBag.Error = "";
                    }
                    else
                    {
                        ViewBag.Error = svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    ViewBag.Error = ex.Message;
                }

                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_EventRequest", ViewBag);
            }
            return rt;
        }

        /// <summary>
        /// 근무조정 신청
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SendRequest()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["userid"].ToString() == "" || jPost["subject"].ToString() == "") return "필수값 누락!";
                    if (jPost["sub"] == null) return "조정 항목 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.InsertWorkTimeRequest(Convert.ToInt32(jPost["userid"]), jPost["workdate"].ToString()
                                            , jPost["subject"].ToString(), jPost["reason"].ToString(), (JArray)jPost["sub"]);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK";
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

        /// <summary>
        /// 근무조정 신청 승인 처리
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DoRequest()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    string sStatus = "";

                    if (jPost == null || jPost.Count == 0 || jPost["step"].ToString() == "" || jPost["ss"].ToString() == "" || StringHelper.SafeInt(jPost["reqid"]) == 0) return "필수값 누락!";

                    if (jPost["ss"].ToString() == "reject") sStatus = "8";
                    //else if (jPost["ss"].ToString() == "approval") sStatus = "7";
                    else sStatus = "7";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.SetWorkTimeRequest(jPost["step"].ToString(), StringHelper.SafeInt(jPost["reqid"]), StringHelper.SafeInt(jPost["apvid"])
                                        , jPost["apvdn"].ToString(), StringHelper.SafeInt(jPost["apvdeptid"]), jPost["apvdept"].ToString()
                                        , jPost["apvgrade"].ToString(), sStatus, jPost["apvcmnt"].ToString(), (JArray)jPost["sub"]);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK";
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

        /// <summary>
        /// 조정신청 갯수 가져오기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string RequestCount()
        {
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();
                if (jPost == null || jPost.Count == 0 || jPost["ur"].ToString() == "" || jPost["chief"].ToString() == "" || jPost["mo"].ToString() == "")
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;

                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    svcRt = wtBiz.GetWorkTimeRequestCount(Convert.ToInt32(jPost["ur"]), jPost["chief"].ToString(), jPost["mo"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    rt = "OK" + svcRt.ResultDataString;
                }
                else
                {
                    //에러페이지
                    rt = svcRt.ResultMessage;
                }
            }

            return rt;
        }
        #endregion

        #region [근무상태 팝업, 자동알림]
        /// <summary>
        /// 근무상태창 열기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string StatusWnd()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0 || jPost["ws"].ToString() == "") return "필수값 누락!";
                if (jPost["ws"].ToString() == "N/A") return "근무관리 해당 없음!";

                ViewBag.WorkStatus = jPost["ws"].ToString();
                ViewBag.InTime = jPost["intime"].ToString();
                ViewBag.OutTime = jPost["outtime"].ToString();

                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_StatusWnd", ViewBag);
            }
            return rt;
        }

        /// <summary>
        /// 근무상태 자동알림창 열기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string AutoNotice()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0 || jPost["ws"].ToString() == "") return "필수값 누락!";
                if (jPost["ws"].ToString() == "N/A") return "근무관리 해당 없음!";

                ViewBag.WorkStatus = jPost["ws"].ToString();
                ViewBag.PopTime = jPost["poptime"].ToString();
                //ViewBag.StdTime = jPost["stdtime"].ToString();
                //ViewBag.AscTime = jPost["asctime"].ToString();

                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_AutoNotice", ViewBag);
            }
            return rt;
        }

        /// <summary>
        /// 근무상태 이벤트 설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string StatusEvent()
        {
            string strView = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0 || jPost["ss"].ToString() == "")
                {
                    return "필수값 누락!";
                }

                bool bOff = StringHelper.SafeString(jPost["off"]) == "Y" ? true : false;

                string sUA = CommonUtils.UserAgent(Request.ServerVariables["HTTP_USER_AGENT"]);
                string sWorkStatusText = "";

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                
                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    svcRt = wtBiz.SetWorkTimeStatus(Convert.ToInt32(Session["URID"]), DateTime.Now.ToString("yyyy-MM-dd")
                                                , jPost["ss"].ToString(), Request.ServerVariables["REMOTE_HOST"], sUA, bOff);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    if (jPost["ss"].ToString() == "N") sWorkStatusText = Resources.Global.InWork;
                    else if (jPost["ss"].ToString() == "B") sWorkStatusText = Resources.Global.InRest;
                    else if (jPost["ss"].ToString() == "O") sWorkStatusText = Resources.Global.InOut;
                    else if (jPost["ss"].ToString() == "T") sWorkStatusText = Resources.Global.InBiz;
                    else if (jPost["ss"].ToString() == "E") sWorkStatusText = Resources.Global.InTraining;

                    strView = "OK" + sWorkStatusText;
                }
                else
                {
                    //에러페이지
                    strView = svcRt.ResultMessage;
                }
            }
            return strView;
        }

        /// <summary>
        /// 퇴근 처리
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public string OffWork()
        {
            string rt = "필수 정보 누락!";

            if (Request["ss"] != null && Request["ss"].ToString() == "Z"
                && Request["off"] != null && Request["off"].ToString() == "Y")
            {
                try
                {
                    string sIP = Request.ServerVariables["REMOTE_ADDR"];
                    bool bValid = CommonUtils.WorkIPBand(sIP);

                    if (bValid)
                    {
                        string sUA = CommonUtils.UserAgent(Request.ServerVariables["HTTP_USER_AGENT"]);

                        ZumNet.Framework.Core.ServiceResult svcRt = new Framework.Core.ServiceResult();
                        using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                        {
                            svcRt = wtBiz.SetWorkTimeStatus(Convert.ToInt32(Session["URID"]), DateTime.Now.ToString("yyyy-MM-dd")
                                                        , Request["ss"].ToString(), Request.ServerVariables["REMOTE_HOST"], sUA, true);
                        }
                        if (svcRt != null && svcRt.ResultCode == 0) rt = "OK";
                        else rt = svcRt.ResultMessage;
                    }
                    else rt = "요청 처리를 위한 비허용 IP 대역대";
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [근무시간 계산]
        /// <summary>
        /// 근무시간 계산
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string TotalTime()
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                int iWorkingDay = 0;
                int iEnableWork = 0;
                long lMonthMinHour = 0;
                long lRegularTime = 0;
                long lMonthTotal = 0;
                long lRealTotal = 0;
                long lExtraTotal = 0;
                long lDailyTime = 0;

                long lRegularTotal = 0;
                long lExtraTotal2 = 0;
                long lWeekAvg = 0;

                bool bTodayHoliday = false;

                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["wd"].ToString() == "" || jPost["ur"].ToString() == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    DateTime dtWorkDate = Convert.ToDateTime(jPost["wd"]);

                    sPos = "210";
                    using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wtBiz = new BSL.ServiceBiz.WorkTimeBiz())
                    {
                        svcRt = wtBiz.GetTotalWorkTime(Convert.ToInt32(Session["URID"]), jPost["wd"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        
                        //금일까지 근무일수 계산
                        for (int i = 1; i <= dtWorkDate.Day; i++)
                        {
                            DateTime dt = new DateTime(dtWorkDate.Year, dtWorkDate.Month, i);
                            bool bHoliday = CheckHoliday(dt, svcRt.ResultDataRowCollection);

                            if (!bHoliday) iEnableWork++;

                            if (i == dtWorkDate.Day && bHoliday) bTodayHoliday = true;
                        }

                        sPos = "310";
                        if (svcRt.ResultDataRow != null)
                        {
                            iWorkingDay = Convert.ToInt32(svcRt.ResultDataRow["WorkDay"]);
                            lMonthMinHour = Convert.ToInt64(svcRt.ResultDataRow["MonthMinHour"]);
                            lRegularTime = Convert.ToInt64(svcRt.ResultDataRow["RegularTime"]);
                            lMonthTotal = (svcRt.ResultDataRow["MonthTotal"].ToString() == "") ? 0 : Convert.ToInt64(svcRt.ResultDataRow["MonthTotal"]);
                            lRealTotal = (svcRt.ResultDataRow["RealTotal"].ToString() == "") ? 0 : Convert.ToInt64(svcRt.ResultDataRow["RealTotal"]);
                            lExtraTotal = (svcRt.ResultDataRow["ExtraTotal"].ToString() == "") ? 0 : Convert.ToInt64(svcRt.ResultDataRow["ExtraTotal"]);

                            lRegularTotal = (svcRt.ResultDataRow["RegularTotal"].ToString() == "") ? 0 : Convert.ToInt64(svcRt.ResultDataRow["RegularTotal"]);
                            lExtraTotal2 = (svcRt.ResultDataRow["ExtraTotal2"].ToString() == "") ? 0 : Convert.ToInt64(svcRt.ResultDataRow["ExtraTotal2"]);
                        }

                        sPos = "400";
                        //이벤트 기록 확인
                        lDailyTime = CalcWorkTimeDaily(svcRt.ResultDataSet, jPost["wd"].ToString());

                        sPos = "500";
                        //if (jPost["hd"] != null && jPost["hd"].ToString() == "Y") bTodayHoliday = true;
                        if (bTodayHoliday) lExtraTotal += lDailyTime;
                        else
                        {
                            if (lDailyTime >= lRegularTime)
                            {
                                lRegularTotal += lRegularTime;
                                lExtraTotal2 += (lDailyTime - lRegularTime);
                            }
                            else lRegularTotal += lDailyTime;
                        }

                        sPos = "510";
                        if (lExtraTotal2 < 0) lRegularTotal += lExtraTotal2;
                        else lExtraTotal += lExtraTotal2;

                        lWeekAvg = lRegularTotal / iEnableWork * 5 + lExtraTotal / dtWorkDate.Day * 7;

                        sPos = "520";
                        TimeSpan tpMonth = new TimeSpan(lMonthTotal + lDailyTime);
                        TimeSpan tpDay = new TimeSpan(lDailyTime);
                        TimeSpan tpReal = new TimeSpan(lRegularTotal);
                        TimeSpan tpExtra = new TimeSpan(lExtraTotal);
                        //double dWeekAvg = tpMonth.TotalHours / iEnableWork * 5; //tpMonth.TotalHours / iWorkingDay * 5;

                        sPos = "530";
                        StringBuilder sb = new StringBuilder();
                        sb.AppendFormat("^{0};{1}", tpDay.Hours.ToString(), tpDay.Minutes.ToString()); //일 근무시간
                        sb.AppendFormat("^{0};{1}", (tpMonth.Days * 24 + tpMonth.Hours), tpMonth.Minutes.ToString()); //월 누적 근무시간
                        sb.AppendFormat("^{0}", tpReal.TotalHours.ToString("#.##")); //월 근무인정 시간
                        sb.AppendFormat("^{0}", tpExtra.TotalHours.ToString("#.##")); //월 잔업인정 시간
                        //sb.AppendFormat("^{0}", dWeekAvg.ToString("#.##")); //주당 평균근무시간
                        sb.AppendFormat("^{0}", (new TimeSpan(lWeekAvg)).TotalHours.ToString("#.##")); //주당 평균근무시간

                        rt = "OK" + sb.ToString();
                    }
                    else
                    {
                        //에러페이지
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
        #endregion

        #region [유틸 함수]
        /// <summary>
        /// DB에 설정된 휴일과 비교해 휴일 여부 반환
        /// </summary>
        /// <param name="d"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        private bool CheckHoliday(DateTime d, DataRowCollection h)
        {
            bool bHoliday = false;

            if (d.DayOfWeek != DayOfWeek.Sunday && d.DayOfWeek != DayOfWeek.Saturday)
            {
                if (h != null && h.Count > 0)
                {
                    foreach (DataRow dr in h)
                    {
                        if (dr["Item2"].ToString() == "Y" && dr["ItemSubHandler"].ToString() == d.ToString("yyyyMMdd"))
                        {
                            //Response.Write("휴일=>" + dr["ItemSubHandler"].ToString() + "<br />");
                            bHoliday = true; break;
                        }
                    }
                }
            }
            else
            {
                bHoliday = true;
            }
            return bHoliday;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="evt"></param>
        /// <param name="workDate"></param>
        /// <returns></returns>
        private long CalcWorkTimeDaily(DataSet evt, string workDate)
        {
            #region [변수선언]
            DataTable dtEvent = null;
            ZumNet.Framework.Entities.WorkTime.WorkEventList workEventList = null;
            ZumNet.Framework.Entities.WorkTime.WorkEvent workEvent = null;
            ZumNet.Framework.Entities.WorkTime.WorkEvent searchEvt = null;

            string sBizTrip = "";   //출장
            string sLcm = "";       //교육
            string sOutWork = "";   //외근
            string sLeave = "";     //휴가
            string sSent = "";      //파견
            string sNight = "";     //야간근무
            string sHoliday = "";   //휴일근무

            string sSubClass = "";
            string sFromTime = "";
            string sTimeType = "";

            string sPlanInTime = "";
            string sPlanOutTime = "";
            string sLimitInTime = "";   //20-03-22 출근제한시각
            string sLimitOutTime = "";  //20-03-22 퇴근제한시각
            string sInTime = "";
            string sOutTime = "";

            string sStartTime = "";
            string sEndTime = "";

            string sSearchStart = "";
            string sSearchEnd = "";

            bool bLunch = true;     //점심시간(12:30~13:00 고려)

            long lRealTime = 0;     //계산된 실제 근무시간
            long lLunchTime = 0;    //점심시간
            #endregion

            #region [출장, 외근, 휴가, 교육 등 확인]
            if (evt.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in evt.Tables[0].Rows)
                {
                    if (row["WorkStatus"].ToString() == "B") //출장
                    {
                        sBizTrip = row["WorkStatus"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "E") //사외교육
                    {
                        sLcm = row["WorkStatus"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "L") //휴가
                    {
                        sLeave = row["WorkStatus"].ToString();
                        sSubClass = row["SubClass"].ToString();
                        sFromTime = row["FromTime"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "O") //외근
                    {
                        sOutWork = row["WorkStatus"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "O") //파견
                    {
                        sSent = row["WorkStatus"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "O") //야간근무
                    {
                        sNight = row["WorkStatus"].ToString();
                    }
                    else if (row["WorkStatus"].ToString() == "O") //휴일근무
                    {
                        sHoliday = row["WorkStatus"].ToString();
                    }
                }
            }

            if (sBizTrip != "" || sLcm != "" || sSent != "")
            {
                lRealTime = (new TimeSpan(8, 0, 0)).Ticks;
                sTimeType = "D";
            }
            else if (sOutWork != "")
            {
                //외근도 일단 8시간으로
                lRealTime = (new TimeSpan(8, 0, 0)).Ticks;
                sTimeType = "D";
            }
            else if (sLeave != "")
            {
                sLeave = LeaveType(sSubClass, sFromTime);
                sTimeType = sLeave.Substring(1);
            }

            //1/2, 14에 따른 시작, 종료 시각 계산
            if (sTimeType == "A2")
            {
                //오전반차  08:30~12:30, 09:00~14:00
                if (Convert.ToInt16(sFromTime.Split(':')[0]) == 8) sSearchStart = workDate + " 13:30";
                else sSearchStart = workDate + " 14:00";

                lRealTime = (new TimeSpan(4, 0, 0)).Ticks;
                //bLunch = false;
            }
            else if (sTimeType == "P2")
            {
                //오후반차 13:30~17:30, 14:00~18:00
                if (Convert.ToInt16(sFromTime.Split(':')[0]) == 13) sSearchEnd = workDate + " 13:30:00";
                else sSearchEnd = workDate + " 14:00:00";
                //sSearchEnd = workDate + " 12:30:00";

                lRealTime = (new TimeSpan(4, 0, 0)).Ticks;
                //bLunch = false;
            }
            else if (sTimeType == "A1")
            {
                //오전 1/4차
                sSearchStart = workDate + " 11:00";
                lRealTime = (new TimeSpan(2, 0, 0)).Ticks;
            }
            else if (sTimeType == "P1")
            {
                //오후 1/4차
                sSearchEnd = workDate + " 16:00";
                lRealTime = (new TimeSpan(2, 0, 0)).Ticks;
            }
            #endregion

            //계획 근무시간 확인
            foreach (DataRow row in evt.Tables[1].Rows)
            {
                sPlanInTime = workDate + " " + row["PlanInTime"].ToString();
                sPlanOutTime = workDate + " " + row["PlanOutTime"].ToString();

                sLimitInTime = workDate + " " + row["LimitInTime"].ToString();
                sLimitOutTime = Convert.ToDateTime(workDate).AddDays(1).ToString("yyyy-MM-dd") + " " + row["LimitOutTime"].ToString(); //다음날 새벽 1시
            }

            //이벤트 기록 확인
            dtEvent = evt.Tables[2];
            if (dtEvent.Rows.Count > 0)
            {
                #region [엔터티 구성 & 기록 처음 끝 시간간격]
                workEventList = new Framework.Entities.WorkTime.WorkEventList();
                foreach (DataRow row in dtEvent.Rows)
                {
                    workEvent = new Framework.Entities.WorkTime.WorkEvent();
                    workEvent.SetEntities(Convert.ToInt32(row["RegID"]), row["WorkStatus"].ToString(), row["EventTime"].ToString());

                    workEventList.Add(workEvent);
                }

                //처음 나오는 출근 기록
                searchEvt = workEventList.Find("A");
                if (searchEvt != null) sInTime = searchEvt.EventTime.ToString("yyyy-MM-dd HH:mm:ss");
                searchEvt = null;

                //마지막에 나오는 퇴근 기록, 퇴근취소 경우 고려
                searchEvt = workEventList.Last("Z", sInTime);
                if (searchEvt != null)
                {
                    Framework.Entities.WorkTime.WorkEvent temp = workEventList.Find("N", searchEvt.RegID); //퇴근 이후 근무상태가 있으면
                    if (temp != null)
                    {
                    }
                    else
                    {
                        sOutTime = searchEvt.EventTime.ToString("yyyy-MM-dd HH:mm:ss");
                    }
                }
                searchEvt = null;

                //sStartTime = (sInTime == "") ? sPlanInTime : sInTime;
                //sEndTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                if (sInTime == "")
                {
                    sStartTime = sPlanInTime;
                }
                else
                {
                    if (DateTime.Compare(Convert.ToDateTime(sInTime), Convert.ToDateTime(sLimitInTime)) < 0)
                    {
                        //제한시간 이전이면 제한시간으로
                        sStartTime = sLimitInTime;
                    }
                    else
                    {
                        sStartTime = sInTime;
                    }
                }

                if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(sLimitOutTime)) > 0)
                {
                    //제한시간 이후이면 제한시간으로
                    sEndTime = sLimitOutTime;
                }
                else
                {
                    sEndTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                }
                #endregion

                if (bLunch && DateTime.Compare(DateTime.Now, Convert.ToDateTime(workDate + " 13:30:00")) > 0)
                {
                    //점심시간대 근무제외 시간 계산 - 최대 1시간
                    lLunchTime = workEventList.WorkTime(workDate + " 12:30:00", workDate + " 13:30:00");
                }

                if (sSearchStart != "")
                {
                    if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(sSearchStart)) > 0)
                    {
                        lRealTime += workEventList.WorkTime(sSearchStart, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    }
                    else
                    {
                        if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(workDate + " 12:30:00")) < 0)
                        {
                            lRealTime = workEventList.WorkTime(sStartTime, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        }
                    }
                }
                else if (sSearchEnd != "")
                {
                    if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(sSearchEnd)) > 0)
                    {
                        if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(workDate + " 18:00:00")) > 0)
                        {
                            lRealTime += workEventList.WorkTime(sStartTime, sSearchEnd) - lLunchTime;
                        }
                        else
                        {
                            lRealTime = workEventList.WorkTime(sStartTime, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")) - lLunchTime;
                        }
                    }
                    else
                    {
                        lRealTime = workEventList.WorkTime(sStartTime, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")) - lLunchTime;
                    }

                }
                else
                {
                    lRealTime = workEventList.WorkTime(sEndTime) - lLunchTime;
                }
            }
            else
            {
                #region [이벤트기록이 없는 경우]
                //근무일 기준 출장,휴가,외근,교육 등이 없으면 "결근"으로 간주
                //if (holidayType == "N")
                //{
                //    if (sBizTrip == "" && sLcm == "" && sOutWork == "" && sLeave == "" && sSent == "")
                //    {
                //        lRealTime = 0;
                //    }
                //}
                //else
                //{
                //    //휴일 실제근무기록 0
                //    lRealTime = 0;
                //}
                #endregion
            }

            if (dtEvent != null) { dtEvent.Dispose(); dtEvent = null; }

            return lRealTime;
        }

        /// <summary>
        /// 휴가구분
        /// </summary>
        /// <param name="cls"></param>
        /// <param name="from"></param>
        /// <param name="time"></param>
        /// <returns></returns>
        private string LeaveType(string cls, string from)
        {
            //A	공가
            //B	연차
            //C	반차
            //D	1/4차
            //E	보건휴가
            //F	결근
            //G	기타
            //H	오전반차
            //I	오후반차

            string sRt = "";
            //long lTime = 0;

            if (cls == "B")
            {
                sRt = cls + "D";
                //lTime = (new TimeSpan(8, 0, 0)).Ticks;
            }
            if (cls == "C" || cls == "H" || cls == "I")
            {
                string[] v = from.Split(':');
                if (Convert.ToInt16(v[0]) <= 12) sRt = "A2";
                else sRt = "P2";

                sRt = "C" + sRt;
                //lTime = (new TimeSpan(4, 0, 0)).Ticks;
            }
            else if (cls == "D")
            {
                string[] v = from.Split(':');
                if (Convert.ToInt16(v[0]) <= 12) sRt = "A1";
                else sRt = "P1";

                sRt = cls + sRt;
                //lTime = (new TimeSpan(2, 0, 0)).Ticks;
            }
            else
            {
                sRt = cls + "D";
                //lTime = (new TimeSpan(8, 0, 0)).Ticks;
            }
            //time = lTime;
            return sRt;
        }
        #endregion
    }
}