using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZumNet.DAL.ServiceDac;
using ZumNet.Framework.Util;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class CorpCardController : Controller
    {
        // GET: ExS/CorpCard
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

            //ZumNet.Framework.Core.ServiceResult svcRt = null;

            //권한, 초기 설정 가져오기
            rt = Bc.CtrlHandler.CorpCardInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission;
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
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

                    //ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    string formTable = jPost["ft"].ToString();

                    //초기 설정
                    sPos = "300";
                    rt = Bc.CtrlHandler.CorpCardInit(this, true);
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    sPos = "400";

                    rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                            + jPost["lv"]["boundary"].ToString()
                            + RazorViewToString.RenderRazorViewToString(this, "_ListMenu", ViewBag)
                            + jPost["lv"]["boundary"].ToString()
                            + RazorViewToString.RenderRazorViewToString(this, "_ListPagination", ViewBag);
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }

            return rt.TrimStart();
        }

        #region [카드정보, 사용현황 화면]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CardView()
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
                    rt = Bc.CtrlHandler.CardCode(this);
                    if (rt != "") throw new Exception(rt);

                    if (jPost["M"].ToString() == "new")
                    {
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rpBiz.GetReport("ci", StringHelper.SafeInt(jPost["oid"]), jPost["ft"].ToString(), "", "", "", "", "", "", "");
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.CardInfo = svcRt.ResultDataSet;
                            ViewBag.JPost = jPost;
                        }
                        else
                        {
                            //에러페이지
                            rt = svcRt.ResultMessage;
                        }
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_CardView", ViewBag);
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
        public string CardAck()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["ft"].ToString() == "" || StringHelper.SafeInt(jPost["oid"]) == 0) return "필수값 누락!";

                    //초기 설정
                    rt = Bc.CtrlHandler.CardCode(this);
                    if (rt != "") throw new Exception(rt);

                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport("ai", StringHelper.SafeInt(jPost["oid"]), jPost["ft"].ToString(), "", "", "", "", "", "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.CardInfo = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_CardAck", ViewBag);
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
        public string VchInfo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "" || jPost["ft"].ToString() == "" || StringHelper.SafeInt(jPost["oid"]) == 0) return "필수값 누락!";

                    //초기 설정
                    rt = Bc.CtrlHandler.CardCode(this);
                    if (rt != "") throw new Exception(rt);

                    using (ZumNet.BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport("vi", StringHelper.SafeInt(jPost["oid"]), jPost["ft"].ToString(), "", "", "", "", "", "", "");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.VchInfo = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }

                    if (rt == "") rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_VchInfo", ViewBag);
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [카드정보 저장, 수정, 삭제 / 카드사용정보 메모(사용예외처리)]
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CardSave()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || !jPost.ContainsKey("ccid")) return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetCARDINFO(StringHelper.SafeInt(jPost["ccid"]), jPost);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK" + svcRt.ResultDataString;
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CardLink()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ccid"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetCARDLINK(StringHelper.SafeInt(jPost["ccid"]), jPost);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        rt = "OK"; // + svcRt.ResultDataString;
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CardDelete()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ccid"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.DeleteCARDINFO(jPost["M"].ToString(), StringHelper.SafeInt(jPost["ccid"]));
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CardAckMemo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["ackid"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetCARDACKMEMO(StringHelper.SafeInt(jPost["ackid"]), jPost);
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string AuthSave()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["useid"].ToString() == "" || jPost["mgrid"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.SetCardAuth(StringHelper.SafeInt(jPost["useid"]), StringHelper.SafeInt(jPost["mgrid"]), jPost["mgrnm"].ToString(), jPost["mgrdept"].ToString(), jPost["add"].ToString(), jPost["del"].ToString());
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
    }
}