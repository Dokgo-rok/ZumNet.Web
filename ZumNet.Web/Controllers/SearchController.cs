using System;
using System.Text;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class SearchController : Controller
    {
        // GET: Search
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ViewBag.R.lv["searchtext"].ToString() != "")
            {
                ZumNet.Framework.Core.ServiceResult svcRt = null;
                int iCategoryId = ViewBag.R.ct != null && ViewBag.R.ct.Value != "" ? Convert.ToInt32(ViewBag.R.ct.Value) : 0;

                ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
                ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? "20" : ViewBag.R.lv["count"].ToString();
                ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "CreateDate" : ViewBag.R.lv["sort"].ToString();
                ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();
                ViewBag.R.lv["search"] = ViewBag.R.lv["search"].ToString() == "" ? "Subject" : ViewBag.R.lv["search"].ToString();

                using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new BSL.ServiceBiz.OfficePortalBiz())
                {
                    svcRt = op.SearchTotalXFormList(Convert.ToInt32(Session["DNID"]), 0, 0, "", Convert.ToInt32(Session["URID"]), iCategoryId, "N"
                            , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                            , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.Mode = "";
                    ViewBag.BoardList = svcRt.ResultDataTable;
                    ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
                }
                else
                {
                    rt = svcRt.ResultMessage;
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

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    sPos = "200";
                    int iCategoryId = jPost["ct"] != null && jPost["ct"].ToString() != "" ? Convert.ToInt32(jPost["ct"].ToString()) : 0;

                    if (jPost["lv"]["searchtext"].ToString() != "")
                    {
                        sPos = "300";
                        using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new BSL.ServiceBiz.OfficePortalBiz())
                        {
                            svcRt = op.SearchTotalXFormList(Convert.ToInt32(Session["DNID"]), 0, 0, "", Convert.ToInt32(Session["URID"]), iCategoryId, "N"
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            sPos = "400";

                            ViewBag.Mode = "ajax";
                            ViewBag.BoardList = svcRt.ResultDataTable;
                            ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Result", ViewBag)
                                    + jPost["lv"]["boundary"].ToString()
                                    + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListPagination.cshtml", ViewBag);
                        }
                        else
                        {
                            //에러페이지
                            rt = svcRt.ResultMessage;
                        }
                    }
                    else
                    {
                        rt = "검색어 누락!";
                    }
                }
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }
            return rt;
        }
    }
}