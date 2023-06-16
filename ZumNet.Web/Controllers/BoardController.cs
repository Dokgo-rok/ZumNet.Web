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
using System.Runtime.CompilerServices;

namespace ZumNet.Web.Controllers
{
    public class BoardController : Controller
    {
        #region [게시물 목록]
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
                svcRt = bd.GetRecentNoticeList(Convert.ToInt32(Session["DNID"]), 0, "", "notice", iCategoryId, Convert.ToInt32(Session["URID"]), 5, "N", Session["Admin"].ToString(), "");
                svcRt2 = bd.GetRecentNoticeList(Convert.ToInt32(Session["DNID"]), 0, "650", "bbs", iCategoryId, Convert.ToInt32(Session["URID"]), 10, "B", Session["Admin"].ToString(), "");
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
            ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);

            //권한체크, 폴더환경정보
            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }

                fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
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

            ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
            ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("").ToString() : ViewBag.R.lv["count"].ToString();
            ViewBag.R.lv["basesort"] = ViewBag.R.lv["basesort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["basesort"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                if (ViewBag.R.xfalias.ToString() == "notice")
                {
                    svcRt = bd.GetMessgaeListInfoAddTopLine(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }
                else if (ViewBag.R.xfalias.ToString() == "anonymous")
                {
                    svcRt = bd.GetAnonymousMessageList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }
                else
                {
                    svcRt = bd.GetMessgaeListInfo(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataRowCollection;
                ViewBag.FolderEnv = fdEnv;
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
                    ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    int iFolderId = Convert.ToInt32(jPost["lv"]["tgt"]);

                    //권한체크, 폴더환경정보
                    sPos = "300";
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        if (Session["Admin"].ToString() == "Y")
                        {
                            ViewBag.R.current["operator"] = "Y";
                        }
                        else
                        {
                            sPos = "310";
                            svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "320";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                        }

                        sPos = "330";
                        fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
                    }

                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
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
                            svcRt = bd.GetMessgaeListInfoAddTopLine(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }
                        else if (jPost["xfalias"].ToString() == "anonymous")
                        {
                            svcRt = bd.GetAnonymousMessageList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                        }
                        else
                        {
                            svcRt = bd.GetMessgaeListInfo(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
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
                        ViewBag.FolderEnv = fdEnv;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListMenu.cshtml", ViewBag)
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
        #endregion

        #region [게시물 작성, 조회, 편집 화면]
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
            ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);
            int iAppId = Convert.ToInt32(ViewBag.R.appid.Value); //messageid

            //권한체크, 폴더환경정보
            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
                fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
            }

            //rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            //if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R") || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R")))
            //{
            //    return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //}

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                if (ViewBag.R.xfalias == "anonymous")
                {
                    svcRt = bd.GetAnonyMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString()
                                , Session.SessionID);
                }
                else
                {
                    svcRt = bd.GetBoardMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                //ViewBag.AppView = svcRt.ResultDataSet.Tables["TBL_BOARD"].Rows[0];
                //ViewBag.AppFile = svcRt.ResultDataSet.Tables["TBL_FILE"];
                //ViewBag.AppReply = svcRt.ResultDataSet.Tables["TBL_REPLY"];
                //ViewBag.AppComment = svcRt.ResultDataSet.Tables["TBL_COMMENT"];

                //ViewBag.AppPrev = svcRt.ResultDataDetail["prevMsgID"].ToString();
                //ViewBag.AppNext = svcRt.ResultDataDetail["nextMsgID"].ToString();

                ViewBag.FolderEnv = fdEnv;
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Read()
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
                    ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    int iFolderId = Convert.ToInt32(jPost["fdid"]);
                    int iAppId = Convert.ToInt32(jPost["appid"]);

                    //권한체크, 폴더환경정보
                    sPos = "300";
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        if (Session["Admin"].ToString() == "Y")
                        {
                            ViewBag.R.current["operator"] = "Y";
                        }
                        else
                        {
                            sPos = "310";
                            svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "320";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                            if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                        }

                        sPos = "330";
                        fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
                    }

                    //if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R") || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R")))
                    //{
                    //    return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    //}

                    sPos = "400";
                    rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    sPos = "500";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (ViewBag.R.xfalias == "anonymous")
                        {
                            svcRt = bd.GetAnonyMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                        , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString()
                                        , Session.SessionID);
                        }
                        else
                        {
                            svcRt = bd.GetBoardMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                        , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "510";
                        ViewBag.FolderEnv = fdEnv;
                        rt = FormHandler.BindFormToJson(this, svcRt);

                        if (rt != "")
                        {
                            rt = "[" + sPos + "] " + rt;
                        }
                        else
                        {
                            string sPartialView = ViewBag.R.xfalias == "anonymous" ? "_AnonymousRead" : "_Read";
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, sPartialView, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + JsonConvert.SerializeObject(ViewBag.R.app);
                        }
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

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Modal()
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
                    int iFolderId = Convert.ToInt32(jPost["fdid"]);
                    int iAppId = Convert.ToInt32(jPost["appid"]);

                    //권한체크, 폴더환경정보
                    sPos = "300";
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        if (Session["Admin"].ToString() == "Y")
                        {
                            ViewBag.R.current["operator"] = "Y";
                        }
                        else
                        {
                            sPos = "310";
                            svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "320";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                            if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                        }
                    }

                    //if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R") || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R")))
                    //{
                    //    return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    //}

                    sPos = "400";
                    rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                    if (rt != "")
                    {
                        return "[" + sPos + "] " + rt;
                    }

                    sPos = "500";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (ViewBag.R.xfalias == "anonymous")
                        {
                            svcRt = bd.GetAnonyMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                        , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString()
                                        , Session.SessionID);
                        }
                        else
                        {
                            svcRt = bd.GetBoardMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                        , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "510";
                        rt = FormHandler.BindFormToJson(this, svcRt);

                        if (rt != "")
                        {
                            rt = "[" + sPos + "] " + rt;
                        }
                        else
                        {
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "Modal", ViewBag) + jPost["lv"]["boundary"].ToString() + ViewBag.SiteMap;
                        }
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

        [SessionExpireFilter]
        [Authorize]
        public ActionResult Write(string Qi)
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
            ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

            //if (ViewBag.R.xfalias == "") ViewBag.R.xfalias = "bbs"; //=> xfalias='' 인 경우 일반게시 또는 공지사항으로 적용

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);
            string sObjectType = iFolderId == 0 ? "" : "O";
            
            if (ViewBag.R.mode.ToString() != "reply") ViewBag.R["appid"] = "0"; //답글이 아니고 신규 작성 경우 appid = 0 이어야 한다!!!

            //권한체크, 폴더환경정보
            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, sObjectType, "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    if (iFolderId > 0)
                    {
                        ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                        if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                    }
                }

                if (iFolderId > 0)  fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
            }

            if (iFolderId > 0)
            {
                if (ViewBag.R.xfalias != "anonymous")
                {
                    //익명게시판 아닌 경우 권한 체크
                    rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "W")))
                    {
                        return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                }                    

                rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                if (rt != "")
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                ViewBag.FolderEnv = fdEnv;
            }
            else
            {
                ViewBag.FolderEnv = null;
            }

            if (ViewBag.R.mode.ToString() == "reply")
            {
                using(ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                {
                    if (ViewBag.R.xfalias == "anonymous") svcRt = bd.GetAnonyMsg(iFolderId, ViewBag.R.appid.ToString(), ViewBag.R.xfalias.ToString(), Session.SessionID);
                    else svcRt = bd.GetBoardMsg(Convert.ToInt32(Session["URID"]), iFolderId, ViewBag.R.appid.ToString(), ViewBag.R.xfalias.ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    rt = FormHandler.BindFormToJson(this, svcRt);
                    if (rt != "") return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
                ViewBag.R["appid"] = "0"; //BindFormToJson에서 parent 설정 후 빈값 설정
            }
            else
            {
                rt = FormHandler.BindFormToJson(this, null);
                if (rt != "") return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult Edit()
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
            ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);
            int iAppId = Convert.ToInt32(ViewBag.R.appid.Value); //messageid

            //권한체크, 폴더환경정보
            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
                fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
            }

            //rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            //if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "E") || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "E")))
            //{
            //    return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //}

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                if (ViewBag.R.xfalias == "anonymous")
                {
                    svcRt = bd.GetAnonyMsgPwd(iAppId.ToString(), ViewBag.R.xfalias.ToString());
                    if (svcRt.ResultCode != 0)
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                    else if (ViewBag.R.lv["cd2"].ToString() != svcRt.ResultDataString)  //익명게시물 비밀번호를 cd2에 할당
                    {
                        rt = Resources.Global.Password_NotMatch;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                    svcRt = null;

                    svcRt = bd.GetAnonyMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString()
                                , Session.SessionID);
                }
                else
                {
                    svcRt = bd.GetBoardMsgView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString()
                                , ViewBag.R.current["operator"].ToString(), ViewBag.R.current["appacl"].ToString(), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.FolderEnv = fdEnv;
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
        #endregion

        #region [게시물 저장, 등록]
        /// <summary>
        /// 게시물 저장, 등록
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Send()
        {
            string strView = "";
            string strMsg = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost["xfalias"].ToString() == "anonymous")
                    {
                        if (StringHelper.SafeInt(jPost["appid"].ToString()) > 0 && jPost.ContainsKey("prevpwd"))
                        {
                            using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                            {
                                svcRt = bb.GetAnonyMsgPwd(jPost["appid"].ToString(), jPost["xfalias"].ToString());
                            }

                            if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                            else if (jPost["prevpwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;

                            svcRt = null;
                        }
                    }

                    if (strView == "")
                    {
                        AttachmentsHandler attachHdr = new AttachmentsHandler();
                        svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), jPost["xfalias"].ToString(), (JArray)jPost["attachlist"], (JArray)jPost["imglist"], jPost["body"].ToString());
                        if (svcRt.ResultCode != 0)
                        {
                            strView = svcRt.ResultMessage;
                        }
                        else
                        {
                            jPost["attachlist"] = (JArray)svcRt.ResultDataDetail["FileInfo"];
                            jPost["imglist"] = (JArray)svcRt.ResultDataDetail["ImgInfo"];
                            jPost["body"] = svcRt.ResultDataDetail["Body"].ToString();
                        }

                        jPost["attachxml"] = attachHdr.ConvertFileInfoToXml((JArray)jPost["attachlist"]);

                        //return "OK" + JsonConvert.SerializeObject(jPost);

                        using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                        {
                            if (jPost["M"].ToString() == "save")
                            {
                                //임시저장
                                svcRt = bb.SetBoardMessagTempSave(jPost);
                                strMsg = "저장 하였습니다";
                            }
                            else
                            {
                                svcRt = bb.SetBoardMessage(jPost);
                                strMsg = "등록 하였습니다";
                            }
                        }

                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else strView = "OK" + strMsg;
                    }
                }
                catch (Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }
        #endregion

        #region [임시저장함 목록, 조회, 편집]
        [SessionExpireFilter]
        [Authorize]
        public ActionResult TempSave(string Qi)
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

            ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
            ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("").ToString() : ViewBag.R.lv["count"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "SavedDate" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetTemporaryMessageList(iCategoryId, Convert.ToInt32(Session["URID"]), Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value)
                                        , ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString(), ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString()
                                        , ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataRowCollection;
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
        public string TempSave()
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

                    int iCategoryId = Convert.ToInt32(jPost["ct"]);

                    sPos = "200";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bd.GetTemporaryMessageList(iCategoryId, Convert.ToInt32(Session["URID"]), Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        ViewBag.BoardList = svcRt.ResultDataRowCollection;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "310";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_TempSaveView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListMenu.cshtml", ViewBag)
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

        [SessionExpireFilter]
        [Authorize]
        public ActionResult TempSaveRead(string Qi)
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

            //int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iAppId = Convert.ToInt32(ViewBag.R.appid.Value); //messageid

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetTemporaryMsgView(Convert.ToInt32(Session["DNID"]), iAppId.ToString(), ViewBag.R.xfalias.ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                rt = FormHandler.BindTempFormToJson(this, svcRt);
                if (rt != "") return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));

                rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                if (ViewBag.R.app["creurid"].ToString() != Session["URID"].ToString())
                {
                    return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult TempSaveEdit()
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
            int iAppId = Convert.ToInt32(ViewBag.R.appid.Value); //messageid

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetTemporaryMsgView(Convert.ToInt32(Session["DNID"]), iAppId.ToString(), ViewBag.R.xfalias.ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                rt = FormHandler.BindTempFormToJson(this, svcRt);
                if (rt != "") return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));

                rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                if (ViewBag.R.app["creurid"].ToString() != Session["URID"].ToString())
                {
                    return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }
        #endregion

        #region [최근 게시물 목록]
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Recent(string Qi)
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

            ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
            ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("").ToString() : ViewBag.R.lv["count"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "CreateDate" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetRecentlyMessageListOfCT(iCategoryId, Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value)
                                , ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString(), ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString()
                                , ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString(), Convert.ToInt32(Session["URID"]));
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataTable.Rows;
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
        public string Recent()
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

                    int iCategoryId = Convert.ToInt32(jPost["ct"]);

                    sPos = "200";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bd.GetRecentlyMessageListOfCT(iCategoryId, Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                        , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString(), Convert.ToInt32(Session["URID"]));
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "300";
                        ViewBag.BoardList = svcRt.ResultDataTable.Rows;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "310";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_RecentView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListMenu.cshtml", ViewBag)
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

        #region [익명게시판 목록]
        /// <summary>
        /// 익명게시판 목록 조회
        /// </summary>
        /// <param name="Qi"></param>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Anonymous(string Qi)
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
            ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);

            //권한체크, 폴더환경정보
            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }

                fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
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

            ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
            ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("").ToString() : ViewBag.R.lv["count"].ToString();
            ViewBag.R.lv["basesort"] = ViewBag.R.lv["basesort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["basesort"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
            {
                svcRt = bd.GetAnonymousMessageList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataRowCollection;
                ViewBag.FolderEnv = fdEnv;
                ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        /// <summary>
        /// 익명게시판 목록 조회
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Anonymous()
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
                    ZumNet.Framework.Entities.Common.FolderEnvironmentEntity fdEnv = null;

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    int iFolderId = Convert.ToInt32(jPost["lv"]["tgt"]);

                    //권한체크, 폴더환경정보
                    sPos = "300";
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        if (Session["Admin"].ToString() == "Y")
                        {
                            ViewBag.R.current["operator"] = "Y";
                        }
                        else
                        {
                            sPos = "310";
                            svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "320";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                        }

                        sPos = "330";
                        fdEnv = cb.GetFolderEnvironmentInfomation(iFolderId, ViewBag.R.xfalias.ToString(), "read");
                    }

                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    sPos = "400";
                    using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bd.GetAnonymousMessageList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"])
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString());

                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";

                        ViewBag.BoardList = svcRt.ResultDataRowCollection;
                        ViewBag.FolderEnv = fdEnv;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_AnonymousView", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListMenu.cshtml", ViewBag)
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

        /// <summary>
        /// 익명게시물 비밀번호 조회
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string AnonyMsgPwd()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["msgid"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bb.GetAnonyMsgPwd(jPost["msgid"].ToString(), jPost["xfalias"].ToString());
                    }

                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else
                    {
                        if (jPost["pwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;
                        else strView = "OK";
                    }
                }
                catch (Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }
        #endregion
    }
}