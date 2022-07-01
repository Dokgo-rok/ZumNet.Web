using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class CEController : Controller
    {
        #region [메인, 목록]
        // GET: ExS/CE
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

            int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);
            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "List"); //기본 페이지 설정
            string formTable = ViewBag.R.ft.ToString();

            //권한, 설정 가져오기
            rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            //if (ViewBag.R.current["operator"].ToString() == "N" && (
            //        ViewBag.R.current["acl"].ToString() == ""
            //        || ((formTable.ToLower() == "grid" || formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist") && !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "W")) //쓰기권한
            //        || (formTable.ToLower() == "deptlist" && ViewBag.R.current["chief"].ToString() != "Y")
            //        || (formTable.ToLower() == "codemgr" && ViewBag.R.current["operator"].ToString() != "Y")
            //        || !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R") //그외 페이지 읽기권한
            //    ))
            //{
            //    return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //}
            bool bPer = true;
            if (ViewBag.R.current["operator"].ToString() == "N")
            {
                if (ViewBag.R.current["acl"].ToString() == "") bPer = false;
                else if ((formTable.ToLower() == "grid" || formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist")) { if (!StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "W")) bPer = false; }
                else if (formTable.ToLower() == "deptlist") { if (ViewBag.R.current["chief"].ToString() != "Y") bPer = false; }
                else if (formTable.ToLower() == "codemgr") { if (ViewBag.R.current["operator"].ToString() != "Y") bPer = false; }
                else if (!StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R")) bPer = false;
            }
            if (!bPer) return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));

            ViewBag.R.lv["page"] = "1";
            ViewBag.R.lv["count"] = StringHelper.SafeString(Bc.CommonUtils.GetLvCookie("cost").ToString(), "20");

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            ZumNet.Framework.Core.ServiceResult svcRt2 = null;
            string sCmd = "";

            if (formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist" || formTable.ToLower() == "list" || formTable.ToLower() == "report")
            {
                if (formTable.ToLower() == "mylist") sCmd = "P";
                else if (formTable.ToLower() == "deptlist") sCmd = "G";
                else sCmd = "";

                if (formTable.ToLower() == "deptlist") ViewBag.R.lv["tgt"] = Convert.ToInt32(Session["DeptID"]);
                else ViewBag.R.lv["tgt"] = Convert.ToInt32(Session["URID"]);

                ViewBag.R.lv["start"] = StringHelper.SafeString(ViewBag.R.lv["start"].ToString(), "1");
                ViewBag.R.lv["searchtext"] = StringHelper.SafeString(ViewBag.R.lv["searchtext"].ToString(), "");
                
                if (ViewBag.R.lv["searchtext"].ToString() != "") ViewBag.R.lv["search"] = "M";
                if (formTable.ToLower() != "report") ViewBag.R.lv["basesort"] = StringHelper.SafeString(ViewBag.R.lv["basesort"].ToString(), "CRDT");
                if (formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist") ViewBag.R.lv["cd1"] = StringHelper.SafeString(ViewBag.R.lv["cd1"].ToString(), "");
            }

            if (formTable.ToLower() == "codemgr")
            {

            }
            else
            {
                using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                {
                    if (formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist" || formTable.ToLower() == "list")
                    {
                        svcRt = cost.GetCELIST(sCmd, StringHelper.SafeInt(ViewBag.R.lv.tgt.Value), ViewBag.R.lv.start.ToString(), StringHelper.SafeString(ViewBag.R.lv.cd1)
                                    , ViewBag.R.lv.sort.ToString(), ViewBag.R.lv.sortdir.ToString(), ViewBag.R.lv.search.ToString(), ViewBag.R.lv.searchtext.ToString());
                    }
                    else if (formTable.ToLower() == "report")
                    {
                        svcRt = cost.GetCEREPORT(sCmd, StringHelper.SafeInt(ViewBag.R.lv.tgt.Value), ViewBag.R.lv.start.ToString()
                                    , "", "", "", "", "", "", "", ViewBag.R.lv.search.ToString(), ViewBag.R.lv.searchtext.ToString());
                    }
                    else if (formTable.ToLower() == "stdexchange")
                    {
                        svcRt = cost.GetXRATE("A", 0, "");

                        svcRt2 = cost.GetXRATE("S", 0, "");
                        ViewBag.StdRate = svcRt2.ResultDataSet;
                    }
                    else if (formTable.ToLower() == "stdexchangedetail")
                    {
                        svcRt = cost.GetXRATE("V", StringHelper.SafeInt(ViewBag.R.appid.Value), "");
                    }
                    else if (formTable.ToLower() == "stdpay")
                    {
                        svcRt = cost.GetSTDPAY("A", 0, "");

                        svcRt2 = cost.GetSTDPAY("S", 0, "");
                        ViewBag.StdRate = svcRt2.ResultDataSet;
                    }
                    else if (formTable.ToLower() == "stdpaydetail")
                    {
                        svcRt = cost.GetSTDPAY("V", StringHelper.SafeInt(ViewBag.R.appid.Value), "");
                    }
                    else if (formTable.ToLower() == "outpay")
                    {
                        svcRt = cost.GetOUTPAY("A", 0, "");

                        svcRt2 = cost.GetOUTPAY("S", 0, "");
                        ViewBag.StdRate = svcRt2.ResultDataSet;
                    }
                    else if (formTable.ToLower() == "outpaydetail")
                    {
                        svcRt = cost.GetOUTPAY("S", StringHelper.SafeInt(ViewBag.R.appid.Value), "");
                    }
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.Mode = ViewBag.R.mode.ToString();
                    ViewBag.BoardList = svcRt.ResultDataSet;
                }
                else
                {
                    rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
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

                    //권한, 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "310";
                    //if (jPost["current"]["operator"].ToString() == "N" && (
                    //        jPost["current"]["acl"].ToString() == ""
                    //        || ((formTable.ToLower() == "grid" || formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist") && !StringHelper.HasAcl(jPost["current"]["acl"].ToString(), "W")) //쓰기권한
                    //        || (formTable.ToLower() == "deptlist" && jPost["current"]["chief"].ToString() != "Y")
                    //        || (formTable.ToLower() == "codemgr" && jPost["current"]["operator"].ToString() != "Y")
                    //        || !StringHelper.HasAcl(jPost["corrent"]["acl"].ToString(), "R") //그외 페이지 읽기권한
                    //    ))
                    //{
                    //    return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    //}
                    bool bPer = true;
                    if (jPost["current"]["operator"].ToString() == "N")
                    {
                        if (jPost["current"]["acl"].ToString() == "") bPer = false;
                        else if ((formTable.ToLower() == "grid" || formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist")) { if (!StringHelper.HasAcl(jPost["current"]["acl"].ToString(), "W")) bPer = false; }
                        else if (formTable.ToLower() == "deptlist") { if (jPost["current"]["chief"].ToString() != "Y") bPer = false; }
                        else if (formTable.ToLower() == "codemgr") { if (jPost["current"]["operator"].ToString() != "Y") bPer = false; }
                        else if (!StringHelper.HasAcl(jPost["corrent"]["acl"].ToString(), "R")) bPer = false;
                    }
                    if (!bPer) return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    string sCmd = "";

                    sPos = "410";
                    if (formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist" || formTable.ToLower() == "list" || formTable.ToLower() == "report")
                    {
                        if (formTable.ToLower() == "mylist") sCmd = "P";
                        else if (formTable.ToLower() == "deptlist") sCmd = "G";
                        else sCmd = "";

                        if (jPost["lv"]["searchtext"].ToString() != "") jPost["lv"]["search"] = "M";
                    }

                    using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                    {
                        if (formTable.ToLower() == "mylist" || formTable.ToLower() == "deptlist" || formTable.ToLower() == "list")
                        {
                            sPos = "420";
                            svcRt = cost.GetCELIST(sCmd, Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString(), jPost["lv"]["cd1"].ToString()
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString());
                        }
                        else if (formTable.ToLower() == "report")
                        {
                            sPos = "430";
                            svcRt = cost.GetCEREPORT(sCmd, Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString()
                                        , "", "", "", "", "", "", "", jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString());
                        }
                        else if (formTable.ToLower() == "__")
                        {
                            sPos = "440";
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";
                        ViewBag.Mode = ViewBag.R.mode.ToString();
                        ViewBag.BoardList = svcRt.ResultDataSet;

                        sPos = "510";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag);
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

        #region [기준정보 조회]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SimpleView()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["ri"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    string[,] codeConfig = { { "ce", "center", "생산지 분류" } };
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        svcRt = cb.SelectCodeDescription(codeConfig);
                    }
                    if (svcRt != null && svcRt.ResultCode == 0) ViewBag.CodeTable = svcRt.ResultDataDetail;
                    else rt = svcRt.ResultMessage;

                    if (rt == "")
                    {
                        using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                        {
                            if (jPost["M"].ToString() == "StdExchange")
                            {
                                svcRt = cost.GetXRATE("S", Convert.ToInt32(jPost["ri"].ToString()), "");
                            }
                            else if (jPost["M"].ToString() == "StdPay")
                            {
                                svcRt = cost.GetSTDPAY("S", Convert.ToInt32(jPost["ri"].ToString()), "");
                            }
                            else if (jPost["M"].ToString() == "OutPay")
                            {
                                svcRt = cost.GetOUTPAY("S", Convert.ToInt32(jPost["ri"].ToString()), "");
                            }
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.Mode = jPost["M"].ToString();
                            ViewBag.StdRate = svcRt.ResultDataSet;

                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + jPost["M"].ToString(), ViewBag);
                        }
                        else
                        {
                            //에러페이지
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
        #endregion

        #region [Grid 관련]
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Grid(string Qi)
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

            int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);

            //권한, 설정 가져오기
            rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "W")) //쓰기권한
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }
        #endregion

        #region [기준정보, 견적표]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SaveStd()
        {
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["M"]) == "" || StringHelper.SafeString(jPost["page"]) == "")
                {
                    return "필수값 누락!";
                }
                else if (jPost["page"].ToString() == "stdpaydetail" && jPost["sub"] == null)
                {
                    return "기준 임율 항목 누락!";
                }
                else if (jPost["page"].ToString() == "grid" && jPost["subtables"] == null)
                {
                    return "견적표 항목 누락!";
                }

                string sMode = StringHelper.SafeString(jPost["M"]);
                string sPage = StringHelper.SafeString(jPost["page"]);
                int iAppId = StringHelper.SafeInt(jPost["appid"]);

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                {
                    if (sPage == "stdexchangedetail")
                    {
                        svcRt = cost.SetStdExchange(iAppId, Convert.ToInt32(Session["URID"]), Session["URName"].ToString()
                                            , Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString(), jPost);
                    }
                    else if (sPage == "stdpaydetail")
                    {
                        svcRt = cost.SetStdPay(sMode, iAppId, jPost["stddt"].ToString(), jPost["xcls"].ToString(), jPost["state"].ToString()
                                    , Convert.ToInt32(Session["URID"]), Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"])
                                    , Session["DeptName"].ToString(), (JArray)jPost["sub"]);
                    }
                    else if (sPage == "outpaydetail")
                    {
                        svcRt = cost.SetOutPay(iAppId, Convert.ToInt32(Session["URID"]), Session["URName"].ToString()
                                            , Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString(), jPost);
                    }
                    else if (sPage == "grid")
                    {
                        svcRt = cost.SetGrid(sMode, sPage, iAppId, StringHelper.SafeInt(jPost["rptmode"]), StringHelper.SafeString(jPost["rptid"])
                                        , jPost["state"].ToString(), StringHelper.SafeString(jPost["istemp"]), Convert.ToInt32(Session["URID"])
                                        , Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString(), jPost);
                    }
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    rt = "OK" + svcRt.ResultDataString + "^저장했습니다!";
                }
                else
                {
                    rt = svcRt == null ? "조건에 해당되는 항목 누락" : svcRt.ResultMessage;
                }
            }

            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SetStd()
        {
            string rt = "";
            string sMsg = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (jPost["page"].ToString() == "" || StringHelper.SafeInt(jPost["appid"]) == 0)
                {
                    return "필수값 누락!";
                }

                string sMode = StringHelper.SafeString(jPost["M"]);
                string sPage = StringHelper.SafeString(jPost["page"]);
                int iAppId = StringHelper.SafeInt(jPost["appid"]);

                if (jPost["state"].ToString() != "") sMode = "S";

                if (sMode == "S") sMsg = "상태 변경 했습니다!";
                else sMsg = "삭제했습니다!";

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                {
                    svcRt = cost.SetSTDINFO(sMode, sPage, iAppId, jPost["state"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    rt = "OK" + sMsg;
                }
                else
                {
                    rt = svcRt.ResultMessage;
                }
            }

            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CopyGrid()
        {
            string rt = "";
            string sMsg = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (jPost["appid"].ToString() == "" || jPost["model"].ToString() == "")
                {
                    return "필수값 누락!";
                }

                int iAppId = StringHelper.SafeInt(jPost["appid"]);

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                {
                    svcRt = cost.CopyGrid(iAppId, Convert.ToInt32(Session["URID"]), Session["URName"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptName"].ToString(), jPost);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    rt = "OK" + svcRt.ResultDataString + "^복사했습니다!";
                }
                else
                {
                    rt = svcRt.ResultMessage;
                }
            }

            return rt;
        }
        #endregion
    }
}