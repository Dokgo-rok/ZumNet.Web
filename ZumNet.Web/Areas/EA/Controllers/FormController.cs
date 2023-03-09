using System;
using System.Collections.Generic;
using System.Text;
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
        #region [양식 불러오기]
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
            string formId = jReq.ContainsKey("fi") ? jReq["fi"].ToString() : "";
            string oId = jReq.ContainsKey("oi") ? jReq["oi"].ToString() : "";
            string workItemId = jReq.ContainsKey("wi") ? jReq["wi"].ToString() : "";
            string msgId = jReq.ContainsKey("mi") ? jReq["mi"].ToString() : "";
            string posId = jReq.ContainsKey("pi") ? jReq["pi"].ToString() : "";
            string bizRole = jReq.ContainsKey("biz") ? jReq["biz"].ToString() : "";
            string actRole = jReq.ContainsKey("act") ? jReq["act"].ToString() : "";
            string externalKey1 = jReq.ContainsKey("k1") ? jReq["k1"].ToString() : "";
            string externalKey2 = jReq.ContainsKey("k2") ? jReq["k2"].ToString() : "";
            string tmsInfo = jReq.ContainsKey("Ba") ? jReq["Ba"].ToString() : "";
            string workNotice = jReq.ContainsKey("wn") ? jReq["wn"].ToString() : "";
            string tp = jReq.ContainsKey("Tp") ? jReq["Tp"].ToString() : "";

            using (EAFormManager fmMgr = new EAFormManager())
            {
                if (xfAlias == "ea")
                {
                    switch (jReq["M"].ToString())
                    {
                        case "new":
                            svcRt = fmMgr.LoadNewServerForm(jReq["M"].ToString(), formId, oId, workItemId, msgId, posId, bizRole, actRole, externalKey1, externalKey2, tmsInfo, workNotice, xfAlias, tp);
                            break;

                        case "read":
                        case "edit":
                            svcRt = fmMgr.LoadServerForm(jReq["M"].ToString(), formId, oId, workItemId, msgId, posId, bizRole, actRole, externalKey1, externalKey2, tmsInfo, workNotice, xfAlias, tp);
                            break;

                        case "print":
                            //LoadPrintForm(GetPostData());
                            break;

                        case "reuse":
                            svcRt = fmMgr.LoadReuseForm(jReq["M"].ToString(), formId, oId, workItemId, msgId, posId, bizRole, actRole, externalKey1, externalKey2, tmsInfo, workNotice, xfAlias, tp);
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
                            svcRt = fmMgr.LoadBFForm(jReq["M"].ToString(), xfAlias, formId, msgId, workNotice);
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
                    if (jReq.ContainsKey("ft")) ViewBag.JForm["ft"] = jReq["ft"].ToString();
                    if (jReq.ContainsKey("Tp")) ViewBag.JForm["tp"] = jReq["Tp"].ToString();
                    if (jReq.ContainsKey("sj")) ViewBag.JForm["doc"]["subject"] = jReq["sj"].ToString();
                }
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
        /// 양식 미리보기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Preview()
        {
            return View();
        }

        /// <summary>
        /// 양식 파일로 저장
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Save()
        {
            JObject jReq;
            string rt = Resources.Global.Auth_InvalidPath;
            string req = StringHelper.SafeString(Request["qi"], "");
            if (req == "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            try
            {
                jReq = JObject.Parse(SecurityHelper.Base64Decode(req));
            }
            catch (Exception ex)
            {
                rt = ex.Message;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            using (EAFormManager fmMgr = new EAFormManager())
            {
                svcRt = fmMgr.LoadHtmlForm(jReq["oi"].ToString(), jReq["mi"].ToString(), jReq["xf"].ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                try
                {
                    ViewBag.FormHtml = svcRt.ResultDataString;
                    ViewBag.Title = svcRt.ResultDataDetail["DocName"];

                    string strBody = RazorViewToString.RenderRazorViewToString(this, "Save", ViewBag);

                    string strFileName = svcRt.ResultDataDetail["DocName"].ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".mht";

                    Framework.Util.MessageHandler msg = new MessageHandler("", "");
                    msg.CharSet = "utf-8";
                    string strInline = msg.ExtractImgSrc(strBody, Session["FrontName"].ToString());
                    string strDown = msg.ConvertHtmlToMime(strBody, "", strInline);

                    string strContentType = MimeMapping.GetMimeMapping(strFileName);
                    byte[] fileBytes = Encoding.UTF8.GetBytes(strDown);
                    strFileName = HttpUtility.UrlEncode(strFileName, new UTF8Encoding()).Replace("+", "%20");

                    return File(fileBytes, strContentType, strFileName);
                }
                catch (Exception ex)
                {
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(ex, this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }
            else
            {
                //에러페이지
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
        }
        #endregion

        #region [양식조회, 읽음/안읽음 표시]
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
                    string sMessageId = jPost["mi"].ToString();
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

                        if (Convert.ToInt32(sMessageId) > 0)
                        {
                            strView = "조회 설정[" + sActiveWI + "]";
                            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                            {
                                svcRt = cb.AddViewCount(jPost["xf"].ToString(), iFolderId, iActorID, Convert.ToInt32(sMessageId), sIP);
                            }
                        }
                    }
                    else
                    {
                        strView = "비결재문서 조회 설정";
                        using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rpBiz.ViewCount(jPost["xf"].ToString(), iFolderId, iActorID, sMessageId, sIP);
                        }
                    }

                    if (svcRt.ResultCode == 0)
                    {
                        if (lWorkNotice > 0)
                        {
                            strView = "나의할일 조회 설정[" + lWorkNotice.ToString() + "]";
                            using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                            {
                                svcRt = rpBiz.ViewWorkItemNotice(jPost["xf"].ToString(), iActorID, sMessageId, lWorkNotice.ToString());
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

        /// <summary>
        /// 양식 읽음, 안읽음 표시
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Read()
        {
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0) return "전송 데이터 누락!";
                else if (!jPost.ContainsKey("M") || !jPost.ContainsKey("xf") || !jPost.ContainsKey("mi")) return "필수값 누락!";

                try
                {
                    ZumNet.Framework.Core.ServiceResult svcRt = new Framework.Core.ServiceResult();

                    using (BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                    {
                        svcRt = ea.SetRead(jPost["M"].ToString(), jPost["xf"].ToString(), Convert.ToInt32(Session["URID"]), jPost["mi"].ToString());
                    }

                    if (svcRt.ResultCode == 0) rt = "OK";
                    else rt += " " + svcRt.ResultMessage;
                }
                catch (Exception ex)
                {
                    rt += " " + ex.Message;
                }
            }
            return rt;
        }
        #endregion

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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DocLink()
        {
            string sPos = "";
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();

                    sPos = "110"; //초기값 설정
                    if (jPost["page"].ToString() == "") jPost["page"] = "1";
                    if (jPost["count"].ToString() == "") jPost["count"] = "10"; //고정
                    if (jPost["sort"].ToString() == "") jPost["sort"] = "CreateDate";
                    if (jPost["search"].ToString() == "") jPost["search"] = "CreatorID";
                    if (jPost["searchtext"].ToString() == "") jPost["searchtext"] = Session["URID"].ToString();

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.ServiceBiz.OfficePortalBiz opBiz = new BSL.ServiceBiz.OfficePortalBiz())
                    {
                        sPos = "200";
                        svcRt = opBiz.SearchTotalXFormList(Convert.ToInt16(Session["DNID"]), 0, 0, "", Convert.ToInt32(Session["URID"]), Convert.ToInt32(jPost["ct"]), "N"
                                            , Convert.ToInt32(jPost["page"]), Convert.ToInt32(jPost["count"]), jPost["sort"].ToString(), jPost["sortdir"].ToString()
                                            , jPost["search"].ToString(), jPost["searchtext"].ToString(), jPost["start"].ToString(), jPost["end"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        ViewBag.JPost = jPost;
                        ViewBag.BoardList = svcRt.ResultDataTable;
                        ViewBag.Total = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "DocLink", ViewBag);
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
        public string DocLinkFile()
        {
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0) return "전송 데이터 누락!";
                else if (jPost["xf"].ToString() == "" || jPost["mi"].ToString() == "") return "필수값 누락!";

                ViewBag.JPost = jPost;
                rt = RazorViewToString.RenderRazorViewToString(this, "DocLinkFile", ViewBag);

                //ZumNet.Framework.Core.ServiceResult svcRt = null;
                //using (BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                //{
                //    sPos = "200";
                //    svcRt = comBiz.GetAttachFileInfo(Convert.ToInt16(Session["DNID"]), Convert.ToInt32(jPost["mi"].ToString()), jPost["xf"].ToString());
                //}

                //if (svcRt != null && svcRt.ResultCode == 0)
                //{
                //    sPos = "300";
                //    ViewBag.JPost = jPost;
                //    ViewBag.BoardList = svcRt.ResultDataTable;

                //    rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "DocLinkFile", ViewBag);
                //}
                //else
                //{
                //    //에러페이지
                //    rt = svcRt.ResultMessage;
                //}
                
            }
            return rt.TrimStart();
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
                        #region [조직도]
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
                        #endregion

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

                        //개인결재선 관련
                        if (jPost["M"].ToString() == "draft" || (ViewBag.CurrentWI != null && ViewBag.CurrentWI.ActRole.IndexOf("__") >= 0))
                        {
                            using (ZumNet.BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                            {
                                sPos = "400";
                                svcRt = ea.GetPersonLine(0, Convert.ToInt32(Session["URID"]));
                                if (svcRt != null && svcRt.ResultCode == 0) ViewBag.PersonLine = svcRt.ResultDataSet;
                                else throw new Exception(svcRt.ResultMessage);
                            }
                        }

                        sPos = "600";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag)
                                + jPost["boundary"].ToString() + sOrgTree;
                    }
                    else if (jPost["M"].ToString() == "read")
                    {
                        using (BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                        {
                            //우선확인자
                            svcRt = wkList.SelectWorkItemCabinet(Convert.ToInt32(jPost["appid"]), "_cf");
                        }
                        if (svcRt != null && svcRt.ResultCode == 0) ViewBag.CF = svcRt.ResultDataSet;
                        else throw new Exception(svcRt.ResultMessage);


                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag);
                    }
                    else if (jPost["M"].ToString() == "reject")
                    {
                        sPos = "200";
                        Framework.Entities.Flow.SchemaList schemaActList = null;
                        string strSchemaOption = jPost["fi"].ToString() + ";" + Session["DeptID"].ToString() + ";" + Session["URID"].ToString();
                        if (jPost["tp"].ToString() != "") strSchemaOption += ";" + jPost["tp"].ToString();

                        Framework.Entities.Flow.WorkItem curWI = null;
                        Framework.Entities.Flow.Activity curAct = null;

                        sPos = "300";
                        using (ZumNet.DAL.FlowDac.ProcessDac procDac = new DAL.FlowDac.ProcessDac())
                        {
                            curWI = procDac.SelectWorkItem(jPost["wi"].ToString());
                            curAct = procDac.GetProcessActivity(curWI.ActivityID);
                        }

                        sPos = "400";
                        using (BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                        {
                            schemaActList = wkList.RetrieveSchemaList(Convert.ToInt32(jPost["def"]), curWI.OID, curAct.Step, curAct.ActivityID, curWI.ParentWorkItemID, strSchemaOption);
                        }

                        sPos = "500";
                        ViewBag.CurrentWI = curWI;
                        ViewBag.CurrentAct = curAct;

                        sPos = "510";
                        ViewBag.SchemaList = schemaActList;

                        sPos = "600";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag);
                    }
                    else if (jPost["M"].ToString() == "personlinedetail")
                    {
                        using (ZumNet.BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                        {
                            svcRt = ea.GetPersonLineDetail(0, Convert.ToInt32(jPost["lineid"]));
                        }
                        if (svcRt != null && svcRt.ResultCode == 0) ViewBag.PersonLineDetail = svcRt.ResultDataSet;
                        else throw new Exception(svcRt.ResultMessage);


                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag);
                    }
                    else if (jPost["M"].ToString() == "dl")
                    {
                        #region [조직도]
                        string sOrgTree = "";
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            sPos = "200";
                            svcRt = cb.GetGradeCode("1", Convert.ToInt32(Session["DNID"]), "A");
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.GradeCode = svcRt.ResultDataRowCollection;
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

                        sPos = "400";
                        using (ZumNet.DAL.FlowDac.EApprovalDac eaDac = new DAL.FlowDac.EApprovalDac())
                        {
                            ViewBag.DL = eaDac.SelectXFormDL(0, jPost["xf"].ToString(), Convert.ToInt32(jPost["appid"]), "xform_dl");
                        }

                        sPos = "500";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "SignLine", ViewBag)
                                + jPost["boundary"].ToString() + sOrgTree;
                        #endregion
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

        #region [문서배포]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SendDL()
        {
            string sPos = "";
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0) return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                    {
                        sPos = "200";
                        svcRt = ea.DistributeEAForm(jPost["xf"].ToString(), Convert.ToInt32(jPost["mi"].ToString()), Convert.ToInt32(jPost["oi"].ToString())
                            , jPost["dt"].ToString(), jPost["dp"].ToString(), jPost["vlu"].ToString(), Convert.ToInt32(jPost["sdid"].ToString())
                            , jPost["sd"].ToString(), jPost["sdmail"].ToString(), jPost["sddept"].ToString(), DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), jPost["rsvd"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK";
                    }
                    else
                    {
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
    }
}