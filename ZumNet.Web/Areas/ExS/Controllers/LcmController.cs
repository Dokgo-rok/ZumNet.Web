using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class LcmController : Controller
    {
        #region [메인, 목록]
        // GET: ExS/Lcm
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

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //권한, 초기 설정 가져오기
            rt = Bc.CtrlHandler.LcmInit(this);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission;
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //검색
            string sSearchText = "";
            if (ViewBag.R.lv["search"].ToString() != "" && ViewBag.R.lv["searchtext"].ToString() != "")
            {
                if (ViewBag.R.lv["search"].ToString() == "_INST_") sSearchText = " AND (InstDN LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%' OR InstructorInfo1 LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%' OR Instructor LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%')";
                else sSearchText = " AND " + ViewBag.R.lv["search"].ToString() + " LIKE '%" + ViewBag.R.lv["searchtext"].ToString() + "%'";
            }

            using (ZumNet.BSL.InterfaceBiz.ReportBiz rpt = new BSL.InterfaceBiz.ReportBiz())
            {
                svcRt = rpt.GetReport(ViewBag.R.mode.ToString(), StringHelper.SafeInt(ViewBag.R.lv["tgt"]), ViewBag.R.ft.ToString()
                                , ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString(), ViewBag.R.lv["cd1"].ToString()
                                , StringHelper.SafeString(ViewBag.R.lv["cd2"]), StringHelper.SafeString(ViewBag.R.lv["cd3"])
                                , StringHelper.SafeString(ViewBag.R.lv["cd4"]), StringHelper.SafeString(ViewBag.R.lv["cd5"])
                                , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["basesort"].ToString()
                                , ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString(), sSearchText);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.Mode = ViewBag.R.mode.ToString();
                ViewBag.BoardList = svcRt.ResultDataSet;
                ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
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
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    string formTable = jPost["ft"].ToString();

                    //권한, 초기 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.LcmInit(this);
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "310";
                    if (jPost["current"]["operator"].ToString() == "N" && (jPost["current"]["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(jPost["current"]["acl"].ToString(), "V")))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    //string sCmd = "";

                    //검색
                    string sSearchText = "";
                    if (jPost["lv"]["search"].ToString() != "" && jPost["lv"]["searchtext"].ToString() != "")
                    {
                        if (jPost["lv"]["search"].ToString() == "_INST_") sSearchText = " AND (InstDN LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%' OR InstructorInfo1 LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%' OR Instructor LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%')";
                        else sSearchText = " AND " + jPost["lv"]["search"].ToString() + " LIKE '%" + jPost["lv"]["searchtext"].ToString() + "%'";
                    }

                    sPos = "410";
                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpt = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpt.GetReport(ViewBag.R.mode.ToString(), Convert.ToInt32(jPost["lv"]["tgt"]), jPost["ft"].ToString()
                                        , jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString(), jPost["lv"]["cd1"].ToString()
                                        , StringHelper.SafeString(jPost["lv"]["cd2"]), StringHelper.SafeString(jPost["lv"]["cd3"])
                                        , StringHelper.SafeString(jPost["lv"]["cd4"]), StringHelper.SafeString(jPost["lv"]["cd5"])
                                        , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"]), jPost["lv"]["basesort"].ToString()
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), sSearchText);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";
                        ViewBag.Mode = ViewBag.R.mode.ToString();
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "510";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListCount", ViewBag);
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

        #region [과정 작성, 조회]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CourseView()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["ft"].ToString() == "") return "필수값 누락!";
                    if (jPost["M"].ToString() != "new" && StringHelper.SafeInt(jPost["oid"]) == 0) return "필수값 누락!";

                    //초기 설정
                    rt = Bc.CtrlHandler.LcmCode(this);
                    if (rt != "") throw new Exception(rt);

                    if (jPost["M"].ToString() == "new")
                    {
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rpBiz.GetReport("CI", StringHelper.SafeInt(jPost["oid"]), jPost["ft"].ToString(), "", "", "", "", "", "", "");
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.CourceInfo = svcRt.ResultDataSet;
                            ViewBag.JPost = jPost;
                        }
                        else
                        {
                            //에러페이지
                            rt = svcRt.ResultMessage;
                        }
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_CourceView", ViewBag);
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
        public string CourseSave()
        {
            string strView = "";
            string strMsg = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0) return "전송 데이터 누락!";
                    if (jPost["M"].ToString() == "" || jPost["ft"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    string sAdmin = jPost["operator"].ToString() == "Y" || StringHelper.HasAcl(jPost["acl"].ToString(), "S") ? "Y" : "N";

                    if (jPost["M"].ToString() == "CHECK")
                    {
                        sPos = "300";
                        using (BSL.InterfaceBiz.ReportBiz rptBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rptBiz.GetReport("CE", Convert.ToInt32(jPost["oid"]), jPost["ft"].ToString(), "", "", Session["URID"].ToString(), sAdmin, "", "", "");
                        }

                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else
                        {
                            sPos = "310";
                            if (svcRt.ResultDataSet != null && svcRt.ResultDataSet.Tables.Count > 0)
                            {
                                string sStatus = svcRt.ResultDataSet.Tables[0].Rows[0]["Status"].ToString();
                                if (sAdmin == "Y" || sStatus != "P")
                                {
                                    if (sStatus == "Y") strView = sStatus;
                                    else if (sStatus == "A") strView = sStatus + "해당 과정으로 작성된 신청서가 있습니다!\n과정변경 경우 신청자들에게 메일알림이 됩니다\n변경 하시겠습니까?";
                                    else strView = "해당 과정으로 작성된 보고서가 있으므로 변경 할 수 없습니다!";
                                }
                                else strView = "권한이 없습니다!";
                            }
                            else strView = "권한체크 실패!";
                        }
                    }
                    else
                    {
                        sPos = "400";
                        AttachmentsHandler attachHdr = new AttachmentsHandler();
                        svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), jPost["xfalias"].ToString(), (JArray)jPost["attachlist"], null, "");
                        if (svcRt.ResultCode != 0)
                        {
                            strView = svcRt.ResultMessage;
                        }
                        else
                        {
                            jPost["attachlist"] = (JArray)svcRt.ResultDataDetail["FileInfo"];
                        }

                        sPos = "410";
                        string sFileInfo = attachHdr.ConvertFileInfoToXml((JArray)jPost["attachlist"]);
                        string sHasAttach = Convert.ToInt32(jPost["attachcount"].ToString()) > 0 ? "Y" : "N";

                        sPos = "500";
                        using (BSL.InterfaceBiz.ReportBiz rptBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rptBiz.SetLCMCOURSE(jPost["M"].ToString(), Convert.ToInt32(jPost["oid"]), jPost["StdYear"].ToString()
                                    , jPost["ClsDN1"].ToString(), jPost["ClsDN2"].ToString(), jPost["ClsDN3"].ToString(), jPost["ClsDN4"].ToString(), ""
                                    , jPost["ClsCD1"].ToString(), jPost["ClsCD2"].ToString(), jPost["ClsCD3"].ToString(), "", ""
                                    , jPost["CourseDN"].ToString(), 0, jPost["InstDN"].ToString(), jPost["Place"].ToString(), 1
                                    , jPost["FromDate"].ToString(), jPost["ToDate"].ToString(), "", "", jPost["DurDay"].ToString(), jPost["DurTime"].ToString()
                                    , "", "", "", "", jPost["Cost1"].ToString(), "", "", "", ""
                                    , jPost["InstructorID"].ToString(), jPost["Instructor"].ToString(), jPost["InstructorInfo1"].ToString(), jPost["InstructorInfo2"].ToString(), ""
                                    , jPost["Contents"].ToString(), jPost["Etc"].ToString(), "", ""
                                    , Convert.ToInt32(Session["URID"]), Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString()
                                    , sHasAttach, sFileInfo);

                            sPos = "510";
                            strMsg = jPost["M"].ToString() == "M" ? "변경 하였습니다" : "저장 하였습니다";

                            sPos = "520";
                            if (jPost["mail"].ToString() == "OK") //메일 알림
                            {
                                string sMailDomain = "@" + ZumNet.Framework.Configuration.Config.Read("DomainName");
                                svcRt = rptBiz.GetReport("CE", Convert.ToInt32(jPost["oid"]), jPost["ft"].ToString(), "", "", Session["URID"].ToString()
                                                , sAdmin, jPost["mail"].ToString(), sMailDomain, "");

                                sPos = "530";
                                if (svcRt.ResultCode != 0) strMsg += "\n\n" + svcRt.ResultMessage;
                                else
                                {
                                    //메일발송 처리는 추후
                                }
                            }
                        }

                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else strView = "OK" + strMsg;
                    }
                }
                catch (Exception ex)
                {
                    strView = "[" + sPos + "] " + ex.Message;
                }
            }
            return strView;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CourseDelete()
        {
            string strView = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0) return "전송 데이터 누락!";
                    else if (jPost["M"].ToString() == "" || jPost["oid"].ToString() == "") return "필수값 누락!";

                    sPos = "200";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    string sAdmin = jPost["operator"].ToString() == "Y" || StringHelper.HasAcl(jPost["acl"].ToString(), "S") ? "Y" : "N";

                    using (BSL.InterfaceBiz.ReportBiz rptBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        sPos = "300";
                        svcRt = rptBiz.GetReport("CD", Convert.ToInt32(jPost["oid"]), jPost["ft"].ToString(), "", "", Session["URID"].ToString(), sAdmin, "", "", "");

                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else
                        {
                            sPos = "310";
                            if (svcRt.ResultDataSet != null && svcRt.ResultDataSet.Tables.Count > 0)
                            {
                                string sStatus = svcRt.ResultDataSet.Tables[0].Rows[0]["Status"].ToString();
                                if (sAdmin == "Y" || sStatus != "P")
                                {
                                    sPos = "320";
                                    if (sStatus == "Y")
                                    {
                                        sPos = "400";
                                        svcRt = rptBiz.DeleteLCMCOURSE(jPost["M"].ToString(), Convert.ToInt32(jPost["oid"]), Convert.ToInt32(Session["URID"])
                                                    , Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString());

                                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                                        else strView = "OK";
                                    }
                                    else strView = "해당 과정으로 작성된 신청서나 보고서가 있으므로 삭제 할 수 없습니다!";
                                }
                                else strView = "권한이 없습니다!";
                            }
                            else strView = "권한체크 실패!";
                        }
                    }
                }
                catch (Exception ex)
                {
                    strView = "[" + sPos + "] " + ex.Message;
                }                
            }
            return strView;
        }
        #endregion

        #region [수강신청 및 결과 정보 화면]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string LcmInfo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["ft"].ToString() == "") return "필수값 누락!";

                    int iLcmId = StringHelper.SafeInt(jPost["oid"]);
                    int iCourseId = StringHelper.SafeInt(jPost["csi"]);

                    //초기 설정
                    //rt = Bc.CtrlHandler.LcmCode(this);
                    //if (rt != "") throw new Exception(rt);

                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport(jPost["M"].ToString(), iLcmId, jPost["ft"].ToString(), "", "", "", "", "", "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.LcmInfo = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_LcmInfo", ViewBag);
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