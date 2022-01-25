using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Util;

namespace ZumNet.Web.Areas.EA.Controllers
{
    public class FormController : Controller
    {
        // GET: EA/Form
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            JObject jReq;
            string rt = Resources.Global.Auth_InvalidPath;
            string req = StringHelper.SafeString(Request["qi"], "");

            if (req == "")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            try
            {
                jReq = JObject.Parse(SecurityHelper.Base64Decode(req));
            }
            catch (Exception ex)
            {
                rt = ex.Message;
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "";
            if (jReq["M"].ToString() == "") rt = "필수 항목[Mode] 누락";
            else if (StringHelper.SafeString(jReq["xf"]) == "") rt = "필수 항목[xfalias] 누락";
            else if (jReq["M"].ToString() == "new" && jReq["fi"].ToString() == "") rt = "필수 항목[FormID] 누락";
            else if ((jReq["M"].ToString() == "read" || jReq["M"].ToString() == "edit" || jReq["M"].ToString() == "html") && StringHelper.SafeInt(jReq["mi"]) == 0) rt = "필수 항목[MessageID] 누락";

            if (rt != "")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            string xfAlias = StringHelper.SafeString(jReq["xf"]);

            using (EAFormManager fmMgr = new EAFormManager())
            {
                if (xfAlias == "ea")
                {
                    switch (jReq["M"].ToString())
                    {
                        case "new":
                            svcRt = fmMgr.LoadNewServerForm(jReq["M"].ToString(), jReq["fi"].ToString(), StringHelper.SafeString(jReq["oi"]), StringHelper.SafeString(jReq["wi"])
                                        , StringHelper.SafeString(jReq["mi"]), StringHelper.SafeString(jReq["pi"]), StringHelper.SafeString(jReq["biz"]), StringHelper.SafeString(jReq["act"])
                                        , StringHelper.SafeString(jReq["k1"]), StringHelper.SafeString(jReq["k2"]), StringHelper.SafeString(jReq["Ba"])
                                        , StringHelper.SafeString(jReq["wn"]), StringHelper.SafeString(xfAlias), StringHelper.SafeString(jReq["tp"]));
                            break;

                        case "read":
                        case "edit":
                            svcRt = fmMgr.LoadServerForm(jReq["M"].ToString(), StringHelper.SafeString(jReq["fi"]), StringHelper.SafeString(jReq["oi"]), StringHelper.SafeString(jReq["wi"])
                                        , StringHelper.SafeString(jReq["mi"]), StringHelper.SafeString(jReq["pi"]), StringHelper.SafeString(jReq["biz"]), StringHelper.SafeString(jReq["act"])
                                        , StringHelper.SafeString(jReq["k1"]), StringHelper.SafeString(jReq["k2"]), StringHelper.SafeString(jReq["Ba"])
                                        , StringHelper.SafeString(jReq["wn"]), StringHelper.SafeString(xfAlias), StringHelper.SafeString(jReq["tp"]));
                            break;

                        case "print":
                            //LoadPrintForm(GetPostData());
                            break;

                        case "reuse":
                            //LoadReuseForm();
                            break;

                        case "html":
                            //LoadHtmlForm();
                            break;

                        case "autosigninfo":
                            //RetrieveAutoSignInfo(JsonData());
                            break;

                        default:
                            break;
                    }
                }
                else
                {
                    switch (jReq["M"].ToString())
                    {
                        case "new":
                        case "read":
                        case "edit":
                        case "html":
                            svcRt = fmMgr.LoadBFForm(jReq["M"].ToString(), xfAlias, StringHelper.SafeString(jReq["fi"]), StringHelper.SafeString(jReq["mi"]), StringHelper.SafeString(jReq["wn"]));
                            break;
                        case "print":
                            //LoadBFPrintForm(GetPostData());
                            break;
                        default:
                            break;
                    }
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.JReq = jReq;
                ViewBag.FormHtml = svcRt.ResultDataString;
                ViewBag.Title = svcRt.ResultDataDetail["DocName"];
                ViewBag.JForm = svcRt.ResultDataDetail["XForm"];
            }
            else
            {
                //에러페이지
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        /// <summary>
        /// 양식 조회수 설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ViewCount()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["xf"]) == "" || StringHelper.SafeString(jPost["actor"]) == "" || StringHelper.SafeString(jPost["mi"]) == "")
                {
                    return "필수값 누락!";
                }

                try
                {
                    strView = "전송값 할당";
                    int iMessageId = StringHelper.SafeInt(jPost["mi"]);
                    int iFolderId = StringHelper.SafeInt(jPost["fdid"]);
                    int iActorID = StringHelper.SafeInt(jPost["actor"]);

                    string sIP = Request.ServerVariables["REMOTE_ADDR"];
                    string sActiveWI = StringHelper.SafeString(jPost["wi"].ToString());
                    long lWorkNotice = StringHelper.SafeLong(jPost["wn"]);


                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost["xf"].ToString() == "ea")
                    {
                        if (sActiveWI != "")
                        {
                            strView = "현 결재자 정보 가져오기";

                            using (ZumNet.DAL.FlowDac.ProcessDac procDac = new DAL.FlowDac.ProcessDac())
                            {
                                Framework.Entities.Flow.WorkItem curWI = procDac.SelectWorkItem(sActiveWI);
                                if (curWI != null)
                                {
                                    //if (curWI.State == (int)Phs.BFF.Entities.ProcessStateChart.WorkItemState.InActive)
                                    //{
                                    if (curWI.ParticipantID.IndexOf("__") < 0 && curWI.ParticipantID != iActorID.ToString())
                                    {
                                        sActiveWI = "";
                                    }
                                    //}
                                    //else
                                    //{
                                    //    sActiveWI = "";
                                    //}
                                }
                            }
                        }

                        if (iMessageId > 0)
                        {
                            strView = "조회 설정[" + sActiveWI + "]";
                            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                            {
                                svcRt = cb.AddViewCount(jPost["xf"].ToString(), iFolderId, iActorID, iMessageId, sIP);
                            }
                        }
                    }
                    else
                    {
                        strView = "비결재문서 조회 설정";
                        using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rpBiz.ViewCount(jPost["xf"].ToString(), iFolderId, iActorID, iMessageId.ToString(), sIP);
                        }
                    }

                    if (svcRt.ResultCode == 0)
                    {
                        if (lWorkNotice > 0)
                        {
                            strView = "나의할일 조회 설정[" + lWorkNotice.ToString() + "]";
                            using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                            {
                                svcRt = rpBiz.ViewWorkItemNotice(jPost["xf"].ToString(), iActorID, iMessageId.ToString(), lWorkNotice.ToString());
                            }
                        }

                        if (svcRt.ResultCode != 0) strView += " " + svcRt.ResultMessage;
                        else strView = "OK";
                    }
                    else
                    {
                        strView += " " + svcRt.ResultMessage;
                    }
                }
                catch (Exception ex)
                {
                    strView += " " + ex.Message;
                }
            }
            return strView;
        }
    }
}