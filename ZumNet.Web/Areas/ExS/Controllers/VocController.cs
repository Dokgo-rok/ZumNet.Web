using System;
using System.Text;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class VocController : Controller
    {
        // GET: ExS/Voc
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        #region [A/S 대장]
        // GET: ExS/Voc/Ledger
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Ledger(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //초기 설정
            rt = Bc.CtrlHandler.VocInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
            {
                svcRt = rpBiz.GetRegisterVOC(ViewBag.R.mode.ToString(), ViewBag.R.lv.start.ToString(), ViewBag.R.lv.end.ToString()
                                , ViewBag.R.lv.cd1.ToString(), ViewBag.R.lv.cd2.ToString(), ViewBag.R.lv.cd3.ToString(), ViewBag.R.lv.cd4.ToString()
                                , ViewBag.R.lv.cd5.ToString(), ViewBag.R.lv.cd6.ToString(), ViewBag.R.lv.cd7.ToString()
                                , StringHelper.SafeInt(ViewBag.R.lv.page.Value), StringHelper.SafeInt(ViewBag.R.lv.count.Value), ViewBag.R.lv.basesort.ToString()
                                , ViewBag.R.lv.sort.ToString(), ViewBag.R.lv.sortdir.ToString(), ViewBag.R.lv.search.ToString(), ViewBag.R.lv.searchtext.ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataSet;
                ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
                ViewBag.M = ViewBag.R.mode.ToString();
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
        public string Ledger()
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

                    //초기 설정
                    sPos = "200";
                    rt = Bc.CtrlHandler.VocInit(this, true);
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }
 
                    sPos = "300";
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetRegisterVOC(jPost["mode"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString()
                                            , jPost["lv"]["cd1"].ToString(), jPost["lv"]["cd2"].ToString(), jPost["lv"]["cd3"].ToString(), jPost["lv"]["cd4"].ToString()
                                            , jPost["lv"]["cd5"].ToString(), jPost["lv"]["cd6"].ToString(), jPost["lv"]["cd7"].ToString()
                                            , StringHelper.SafeInt(jPost["lv"]["page"].ToString()), StringHelper.SafeInt(jPost["lv"]["count"].ToString()), jPost["lv"]["basesort"].ToString()
                                            , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "310";
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
                        ViewBag.M = "ajax";

                        sPos = "320";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "Ledger", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCountBig.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListPagination.cshtml", ViewBag);
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

        #region [A/S 통계 ]
        // GET: ExS/Voc/Statistics
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Statistics(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            //초기 설정
            rt = Bc.CtrlHandler.VocInit(this, true);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            ViewBag.R.lv["tgt"] = StringHelper.SafeString(ViewBag.R.lv["tgt"].ToString(), DateTime.Now.Year.ToString());

            using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
            {
                svcRt = rpBiz.GetRegisterVOC("ST", ViewBag.R.lv["tgt"].ToString(), "", "", "", "", "", "", "", "", 0, 0, "", "", "", "", "");
                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.ST = svcRt.ResultDataSet;
                    ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
                    ViewBag.M = "";
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                svcRt = rpBiz.GetRegisterVOC("PC", "", "", "", "", "", "", "", "", "", 0, 0, "", "", "", "", "");
                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.PCC = svcRt.ResultDataSet;
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            return View();
        }
        #endregion

        #region [A/S 작성, 조회 화면]
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
                    if (jPost == null || jPost.Count == 0 || jPost["acl"].ToString() == "") return "필수값 누락!";

                    //초기 설정
                    rt = Bc.CtrlHandler.VocInit(this);
                    if (rt != "") throw new Exception(rt);

                    if (jPost["M"].ToString() == "new")
                    {
                        ViewBag.JPost = jPost;
                    }
                    else
                    {
                        ZumNet.Framework.Core.ServiceResult svcRt = null;

                        using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                        {
                            svcRt = rpBiz.GetVOC(StringHelper.SafeLong(jPost["oid"].ToString()));
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            ViewBag.VocEvent = svcRt.ResultDataSet;
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ModelInfo()
        {
            string rt = "";
            string sReasonKind = "";
            string sColor = "";

            StringBuilder sb = new StringBuilder();

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0) return "필수값 누락!";

                    //초기 설정
                    rt = Bc.CtrlHandler.VocInit(this);
                    if (rt != "") throw new Exception(rt);

                    foreach (object[] o in ViewBag.CodeTable["voc.prodmodel"])
                    {
                        if (o[4].ToString() == jPost["model"].ToString())
                        {
                            sReasonKind = o[7].ToString();
                            if (o[6].ToString() != "") sColor = o[6].ToString();
                            break;
                        }
                    }

                    //sb.AppendFormat("<select name=\"RegChangeData\" data-field=\"{0}\">", "MODELCOLOR");
                    if (sColor != "")
                    {
                        if (sColor.IndexOf(";") > 0) sb.Append("<option value=\"\">선택</option>");
                        foreach (string c in sColor.Split(';'))
                        {
                            sb.AppendFormat("<option value=\"{0}\">{0}</option>", c);
                        }
                    }
                    else
                    {
                        sb.Append("<option value=\"\">선택</option>");
                        foreach (object[] o in ViewBag.CodeTable["voc.prodcolor"])
                        {
                            sb.AppendFormat("<option value=\"{0}\">{0}</option>", o[4].ToString());
                        }

                    }
                    sb.AppendFormat("<option value=\"{0}\">{1}</option>", "_ETC_", "기타");
                    //sb.Append("</select>");

                    sb.Append((char)7);

                    sb.Append(sReasonKind);

                    rt = "OK" + sb.ToString();
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