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
        // GET: TnC/ToDo
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

            //권한, 초기 설정 가져오기
            rt = Bc.CtrlHandler.ToDoInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //첫 화면 데이터 가져오기
            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "Week"); //기본 주간보기

            return View();
        }

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