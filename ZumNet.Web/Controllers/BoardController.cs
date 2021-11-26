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

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
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

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
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

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            if (ZumNet.Framework.Util.StringHelper.SafeString(ViewBag.R.ttl) == "")
            {
                //Title이 빈값인 경우(Ajax로 불러온 경우 ttl=''로 설정, 이후 로그아웃 되어 returnUrl로 넘어 왔을 때)
                rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                if (rt != "")
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
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
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    //sPos = "320";
                    //rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                    //if (rt != "")
                    //{
                    //    return "[" + sPos + "] " + svcRt.ResultMessage;
                    //}

                    sPos = "400";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (jPost["xfalias"].ToString() == "notice")
                        {
                            svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }
                        else
                        {
                            svcRt = bd.GetMessgaeListInfo(1, iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
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
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListPagination.cshtml", ViewBag);
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

        // GET: Board
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Read(string Qi)
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

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);
            int iAppId = Convert.ToInt32(ViewBag.R.appid.Value); //messageid

            //권한체크
            if (Session["Admin"].ToString() == "Y")
            {
                ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(1, iCategoryId, Convert.ToInt32(Session["URID"]), iAppId, ViewBag.R.xfalias.ToString(), "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "V")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetBoardMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["acl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                //ViewBag.AppView = svcRt.ResultDataSet.Tables["TBL_BOARD"].Rows[0];
                //ViewBag.AppFile = svcRt.ResultDataSet.Tables["TBL_FILE"];
                //ViewBag.AppReply = svcRt.ResultDataSet.Tables["TBL_REPLY"];
                //ViewBag.AppComment = svcRt.ResultDataSet.Tables["TBL_COMMENT"];

                //ViewBag.AppPrev = svcRt.ResultDataDetail["prevMsgID"].ToString();
                //ViewBag.AppNext = svcRt.ResultDataDetail["nextMsgID"].ToString();
                
                rt = FormHandler.BindFormToJson(this, svcRt);
                if (rt != "") return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }
    }
}