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
            //if (jReq["M"].ToString() == "") rt = "필수 항목[Mode] 누락";
            //else if (StringHelper.SafeString(jReq["xf"]) == "") rt = "필수 항목[xfalias] 누락";
            if (jReq["M"].ToString() == "") jReq["M"] = "new";
            if (jReq["xf"].ToString() == "") jReq["xf"] = "ea";

            ViewBag.JReq = jReq;
            rt = Bc.CtrlHandler.EFormInit(this);
            if (rt != "")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
            jReq = ViewBag.JReq;

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            string xfAlias = StringHelper.SafeString(jReq["xf"].ToString());

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
                                        , StringHelper.SafeString(jReq["wn"]), StringHelper.SafeString(xfAlias), StringHelper.SafeString(jReq["Tp"]));
                            break;

                        case "read":
                        case "edit":
                            svcRt = fmMgr.LoadServerForm(jReq["M"].ToString(), StringHelper.SafeString(jReq["fi"]), StringHelper.SafeString(jReq["oi"]), StringHelper.SafeString(jReq["wi"])
                                        , StringHelper.SafeString(jReq["mi"]), StringHelper.SafeString(jReq["pi"]), StringHelper.SafeString(jReq["biz"]), StringHelper.SafeString(jReq["act"])
                                        , StringHelper.SafeString(jReq["k1"]), StringHelper.SafeString(jReq["k2"]), StringHelper.SafeString(jReq["Ba"])
                                        , StringHelper.SafeString(jReq["wn"]), StringHelper.SafeString(xfAlias), StringHelper.SafeString(jReq["Tp"]));
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
                ViewBag.FormHtml = svcRt.ResultDataString;
                ViewBag.Title = svcRt.ResultDataDetail["DocName"];
                ViewBag.JForm = svcRt.ResultDataDetail["XForm"];

                if (jReq["M"].ToString() == "new")
                {
                    if (jReq["ft"] != null) ViewBag.JForm["ft"] = jReq["ft"].ToString();
                    if (jReq["Tp"] != null) ViewBag.JForm["tp"] = jReq["Tp"].ToString();
                    if (jReq["sj"] != null) ViewBag.JForm["doc"]["subject"] = jReq["sj"].ToString();
                }

                if (ViewBag.WorkNotice != null) ViewBag.JForm["wn"] = ViewBag.WorkNotice;
                ViewBag.JForm["preapvwi"] = ViewBag.PreApprovalWI;
                ViewBag.JForm["checkpwd"] = ViewBag.PwdCheck;

                ViewBag.JForm["boundary"] = CommonUtils.BOUNDARY();
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

        #region [문서정보, 관련문서 등]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DocProp()
        {
            string sPos = "";
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.ServiceBiz.DocBiz docBiz = new BSL.ServiceBiz.DocBiz())
                    {
                        sPos = "200";
                        svcRt = docBiz.GetDocLevelKeepYear(Convert.ToInt32(Session["DNID"]));
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        ViewBag.JPost = jPost;
                        ViewBag.DocLevel = svcRt.ResultDataDetail["DocLevel"];
                        ViewBag.KeepYear = svcRt.ResultDataDetail["KeepYear"];

                        sPos = "310";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "DocProp", ViewBag);
                    }
                    else
                    {
                        sPos = "400";
                        //에러페이지
                        rt = "[" + sPos + "] " + svcRt.ResultMessage;
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

        #region [결재선 관리자]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SignLine()
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();
                    ViewBag.JPost = jPost;

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    if (jPost["M"].ToString() == "draft" || jPost["M"].ToString() == "approval")
                    {
                        string sOrgTree = "";
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            sPos = "200";
                            svcRt = cb.GetGradeCode("1", Convert.ToInt32(Session["DNID"]), "A");
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.GradeCode = svcRt.ResultDataRowCollection;
                            else throw new Exception(svcRt.ResultMessage);

                            sPos = "210";
                            svcRt = cb.GetMemberStates(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DeptID"]));
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.UserInfo = svcRt.ResultDataSet;
                            else throw new Exception(svcRt.ResultMessage);
                        }

                        using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                        {
                            sPos = "300";
                            svcRt = op.GetOrgMapInfo(Convert.ToInt32(Session["DNID"]), 0, "D", Convert.ToInt32(Session["DeptID"]), DateTime.Now.ToString("yyyy-MM-dd"), "N");
                            if (svcRt != null && svcRt.ResultCode == 0) sOrgTree = CtrlHandler.OrgTreeString(svcRt);
                            else throw new Exception(svcRt.ResultMessage);

                            sPos = "310";
                            svcRt = op.GetGroupMemberList(Session["DNID"].ToString(), Session["DeptID"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"), "Code1", "", Session["Admin"].ToString());
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.MemberList = svcRt.ResultDataSet;
                            else throw new Exception(svcRt.ResultMessage);
                        }

                        using (ZumNet.BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                        {
                            sPos = "400";
                            svcRt = ea.GetPersonLine(0, Convert.ToInt32(Session["URID"]));
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.PersonLine = svcRt.ResultDataSet;
                            else throw new Exception(svcRt.ResultMessage);
                        }

                        sPos = "500";
                        Framework.Entities.Flow.SchemaList schemaActList = null;
                        string strSchemaOption = jPost["fi"].ToString() + ";" + Session["DeptID"].ToString() + ";" + Session["URID"].ToString();
                        if (jPost["tp"].ToString() != "") strSchemaOption += ";" + jPost["tp"].ToString();

                        if (jPost["M"].ToString() == "approval")
                        {
                            Framework.Entities.Flow.WorkItem curWI = null;
                            Framework.Entities.Flow.Activity curAct = null;

                            sPos = "510";
                            using (ZumNet.DAL.FlowDac.ProcessDac procDac = new DAL.FlowDac.ProcessDac())
                            {
                                curWI = procDac.SelectWorkItem(jPost["wi"].ToString());
                                curAct = procDac.GetProcessActivity(curWI.ActivityID);
                            }

                            sPos = "520";
                            using (ZumNet.DAL.FlowDac.EApprovalDac eaDac = new DAL.FlowDac.EApprovalDac())
                            {
                                ViewBag.DL = eaDac.SelectXFormDL(0, jPost["xf"].ToString(), Convert.ToInt32(jPost["appid"]), "");
                            }

                            sPos = "530";
                            using (BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                            {
                                schemaActList = wkList.RetrieveSchemaList(Convert.ToInt32(jPost["def"]), curWI.OID, curAct.Step, curAct.ActivityID, curWI.ParentWorkItemID, strSchemaOption);
                            }

                            sPos = "540";
                            ViewBag.CurrentWI = curWI;
                            ViewBag.CurrentAct = curAct;
                        }
                        else
                        {
                            sPos = "550";
                            using (BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                            {
                                schemaActList = wkList.RetrieveSchemaList(Convert.ToInt32(jPost["def"]), 0, 0, "", "", strSchemaOption);
                            }
                        }
                        sPos = "590";
                        ViewBag.SchemaList = schemaActList;

                        sPos = "600";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag)
                                + jPost["boundary"].ToString() + sOrgTree;
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
    }
}