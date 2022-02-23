using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.TnC.Controllers
{
    public class ToDoController : Controller
    {
        #region [주간, 월간 일지]
        // GET: TnC/ToDo
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index(string Qi)
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
            rt = Bc.CtrlHandler.ToDoInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz();
            int iTarget = Convert.ToInt32(ViewBag.R.fdid);

            //권한 설정 - 모든권한(자신, 관리자), 조회/댓글(조회권한자), 확인자(부서장)
            if (ViewBag.R.current["appacl"].ToString() != "A")
            {
                svcRt = todo.GetToDoAclOfTarget(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DeptID"]), iTarget);

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    if (svcRt.ResultDataString == "M")
                    {
                        ViewBag.R.current["acl"] = "____RV___M_RV";
                        ViewBag.R.current["appacl"] = svcRt.ResultDataString;
                    }
                    else if (svcRt.ResultDataString == "V")
                    {
                        ViewBag.R.current["acl"] = "____RV_____RV";
                        ViewBag.R.current["appacl"] = svcRt.ResultDataString;
                    }
                    else
                    {
                        rt = Resources.Global.Auth_NoPermission;
                        todo.Dispose();
                        return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                }
                else
                {
                    rt = svcRt == null ? "권한 요청 실패" : svcRt.ResultMessage;
                    todo.Dispose();
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            //첫 화면 데이터 가져오기
            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "Week"); //기본 주간보기
            string cmd = ViewBag.R["ft"].ToString() == "Month" ? "M" : "W";
            svcRt = todo.GetToDoList(ViewBag.R.mode.ToString(), ViewBag.R.ot.ToString(), iTarget, 99, cmd, ViewBag.R.lv["tgt"].ToString(), "", "");
            
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

                    sPos = "200";
                    rt = Resources.Global.Auth_InvalidPath;
                    if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0") return "[" + sPos + "] " + rt;

                    //초기 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.ToDoInit(this, false);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    int iTarget = Convert.ToInt32(jPost["fdid"]);
                    string formTable = jPost["ft"].ToString();
                    string cmd = formTable == "Month" ? "M" : "W";

                    if (formTable == "Week" || formTable == "Month")
                    {
                        sPos = "500";
                        using (ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz())
                        {
                            svcRt = todo.GetToDoList(jPost["mode"].ToString(), jPost["ot"].ToString(), iTarget, 99, cmd, jPost["lv"]["tgt"].ToString(), "", "");
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            sPos = "510";
                            ViewBag.Mode = "ajax";
                            ViewBag.BoardList = svcRt.ResultDataSet;

                            string sDesc = "";
                            if (formTable == "Week")
                            {
                                sDesc = (ViewBag.Monday.Year == DateTime.Now.Year ? "" : ViewBag.Monday.Year.ToString() + "년 ") + ViewBag.Monday.Month.ToString() + "월"
                                    + " " + ViewBag.Monday.Day.ToString() + " ~ " + (ViewBag.Monday.Month == ViewBag.Monday.AddDays(6).Month ? "" : ViewBag.Monday.AddDays(6).Month.ToString() + "월 ")
                                    + ViewBag.Monday.AddDays(6).Day.ToString();
                            }
                            else if (formTable == "Month")
                            {
                                DateTime dtTraget = Convert.ToDateTime(ViewBag.R.lv["tgt"]);
                                sDesc = (dtTraget.Year == DateTime.Now.Year ? "" : dtTraget.Year.ToString() + "년 ") + dtTraget.Month.ToString() + "월";
                            }

                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + sDesc;
                        }
                        else
                        {
                            rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
                        }
                    }
                    else
                    {
                        rt = "조건에 해당되는 화면 누락";
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

        #region [이벤트(일지)]
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

        #region [기타]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Count()
        {
            string sPos = "";
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["tgt"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    sPos = "200";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz())
                    {
                        svcRt = todo.GetToDoCount(jPost["tgt"].ToString(), jPost["mode"].ToString(), jPost["date"].ToString(), "", "");
                    }

                    StringBuilder sb = new StringBuilder();
                    if (svcRt.ResultDataDetail.Count > 0)
                    {
                        sPos = "300";
                        int i = 0;
                        sb.Append("[");
                        foreach (string key in svcRt.ResultDataDetail.Keys)
                        {
                            if (i > 0) sb.Append(",");
                            sb.Append("{");
                            DataRow dr = (DataRow)svcRt.ResultDataDetail[key];
                            sb.AppendFormat("\"{0}\":[{1},{2},{3}]", key, dr["Total"].ToString(), dr["Confirmed"].ToString(), dr["Completed"].ToString());
                            sb.Append("}");
                            i++;
                        }
                        sb.Append("]");
                    }
                    rt = "OK" + sb.ToString();
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }
            return rt;
        }
        #endregion
    }
}