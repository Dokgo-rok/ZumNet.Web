using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.Docs.Controllers
{
    public class EdmController : Controller
    {
        // GET: Docs
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ViewBag.R.ctalias == "kdoc")
            {
                ZumNet.Framework.Core.ServiceResult svcRt = null;

                int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
                ViewBag.R["xfalias"] = "doc";


                using (ZumNet.BSL.ServiceBiz.DocBiz db = new BSL.ServiceBiz.DocBiz())
                {
                    svcRt = db.GetPortalRecentList("10", ViewBag.R["xfalias"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.RecentBBS = svcRt.ResultDataTable;
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            return View();
        }

        // GET: Board
        [SessionExpireFilter]
        [Authorize]
        public ActionResult List(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = "잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);

            //권한체크
            if (Session["Admin"].ToString() == "Y")
            {
                ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            rt = "권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ViewBag.R.lv["page"] = "1";
            ViewBag.R.lv["count"] = Bc.CommonUtils.GetLvCookie("doc").ToString();
            ViewBag.R.lv["basesort"] = "SeqID";
            ViewBag.R.lv["sort"] = "SeqID";

            using (ZumNet.BSL.ServiceBiz.DocBiz db = new BSL.ServiceBiz.DocBiz())
            {
                svcRt = db.GetDocumentMessageList(1, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), "DESC", "", "", "", "");
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataSet;
                //ViewBag.BoardTotal = svcRt.ResultItemCount;
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
        public string List()
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
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    int iFolderId = Convert.ToInt32(jPost["lv"]["tgt"]);

                    //권한체크
                    if (Session["Admin"].ToString() == "Y")
                    {
                        ViewBag.R.current["operator"] = "Y";
                    }
                    else
                    {
                        sPos = "300";
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "310";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                        }
                    }

                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
                    {
                        return "권한이 없습니다!!";
                    }

                    sPos = "400";
                    using (ZumNet.BSL.ServiceBiz.DocBiz db = new BSL.ServiceBiz.DocBiz())
                    {
                        svcRt = db.GetDocumentMessageList(1, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"]), jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString()
                                        , jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";

                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListCount", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListPagination", ViewBag);
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
    }
}