using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class BoardController : Controller
    {
        // GET: Board
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

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            ZumNet.Framework.Core.ServiceResult svcRt2 = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            //int iOpenNode = 0;
            //if (ViewBag.R.opnode.Value != "")
            //{
            //    if (ViewBag.R.opnode.Value.IndexOf('.') > 0)
            //    {
            //        string[] v = ViewBag.R.opnode.Value.Split('.');
            //        iOpenNode = Convert.ToInt32(v[v.Length - 1]);
            //    }
            //    else iOpenNode = Convert.ToInt32(ViewBag.R.opnode.Value);
            //}

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                //svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iOpenNode, Convert.ToInt32(Session["URID"]), Session["Admin"].ToString(), "", 1, 20, "SeqID", "DESC", "", "", "", "");
                svcRt = bd.GetRecentNoticeList(1, 0, "", "notice", iCategoryId, Convert.ToInt32(Session["URID"]), 5, "N", Session["Admin"].ToString(), "");
                svcRt2 = bd.GetRecentNoticeList(1, 0, "650", "bbs", iCategoryId, Convert.ToInt32(Session["URID"]), 10, "B", Session["Admin"].ToString(), "");
            }

            if (svcRt != null && svcRt.ResultCode == 0 && svcRt2 != null && svcRt2.ResultCode == 0)
            {
                ViewBag.RecentNotice = svcRt.ResultDataTable;
                ViewBag.RecentBBS = svcRt2.ResultDataTable;
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
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

                    //svcRt = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
                    //xfalias에 따라 폴더환경설정 고정 (공지 경우만 popup, topline 사용)
                }
            }

            rt = "권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ViewBag.R.lv["page"] = "1";
            ViewBag.R.lv["count"] = Bc.CommonUtils.GetLvCookie("").ToString();
            ViewBag.R.lv["basesort"] = "SeqID";
            ViewBag.R.lv["sort"] = "SeqID";

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                if (ViewBag.R.xfalias.ToString() == "notice")
                {
                    svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), "DESC", "", "", "", "");
                }
                else
                {
                    svcRt = bd.GetMessgaeListInfo(1, iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), "DESC", "", "", "", "");
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataRowCollection;
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
                    string sOperator = "N";
                    string sAcl = "";

                    //권한체크
                    if (Session["Admin"].ToString() == "Y")
                    {
                        sOperator = "Y";
                    }
                    else
                    {
                        sPos = "300";
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "310";
                            sOperator = svcRt.ResultDataDetail["operator"].ToString();
                            sAcl = svcRt.ResultDataDetail["acl"].ToString();
                        }
                    }

                    if (sOperator == "N" && (sAcl == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(sAcl.Substring(0, 6), "V")))
                    {
                        return "권한이 없습니다!!";
                    }

                    sPos = "400";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (jPost["xfalias"].ToString() == "notice")
                        {
                            svcRt = bd.GetMessgaeListInfoAddTopLine(1, Convert.ToInt32(jPost["ct"]), Convert.ToInt32(jPost["lv"]["tgt"]), Convert.ToInt32(Session["URID"])
                                                    , sOperator, sAcl, Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }
                        else
                        {
                            svcRt = bd.GetMessgaeListInfo(1, Convert.ToInt32(jPost["ct"]), Convert.ToInt32(jPost["lv"]["tgt"]), Convert.ToInt32(Session["URID"])
                                                    , sOperator, sAcl, Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }

                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";

                        ViewBag.BoardList = svcRt.ResultDataRowCollection;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListPagination", ViewBag);
                    }
                    else
                    {
                        //에러페이지
                        rt = svcRt.ResultMessage;
                    }
                }
                catch(Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }            
            return rt;
        }
    }
}