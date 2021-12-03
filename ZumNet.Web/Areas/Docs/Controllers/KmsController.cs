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
    public class KmsController : Controller
    {
        #region [게시물 목록]
        // GET: Docs/Kms
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
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

            if (ViewBag.R.ctalias == "kms")
            {
                ZumNet.Framework.Core.ServiceResult svcRt = null;

                int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
                int iCount = 0;
                string sCmd = "";

                ViewBag.R["xfalias"] = "knowledge";

                //메뉴 권한체크 (objecttype='' 이면 폴더권한 체크 X)
                if (Session["Admin"].ToString() == "Y")
                {
                    ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), 0, "", "0");

                        ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                        //ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    }
                    svcRt = null;
                }

                using (ZumNet.BSL.ServiceBiz.KnowledgeBiz kb = new BSL.ServiceBiz.KnowledgeBiz())
                {
                    //최근 지식
                    iCount = 10;
                    sCmd = "list";
                    svcRt = kb.GetKnowledgeList(Convert.ToInt32(Session["DNID"]), iCategoryId, 0, Convert.ToInt32(Session["URID"]), ViewBag.R["xfalias"].ToString()
                                        , ViewBag.R.current["operator"].ToString(), "", 1, iCount, "CreateDate", "DESC", "", "", "", "", sCmd);

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.RecentBBS = svcRt.ResultDataTable;
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                    svcRt = null;

                    //내가 처리할 지식
                    iCount = 5;
                    sCmd = "approval";
                    svcRt = kb.GetKnowledgeList(Convert.ToInt32(Session["DNID"]), iCategoryId, 0, Convert.ToInt32(Session["URID"]), ViewBag.R["xfalias"].ToString()
                                        , ViewBag.R.current["operator"].ToString(), "", 1, iCount, "CreateDate", "DESC", "", "", "", "", sCmd);

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.ListApv = svcRt.ResultDataTable;
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                    svcRt = null;

                    //나의 진행중 지식
                    iCount = 5;
                    sCmd = "processing";
                    svcRt = kb.GetKnowledgeList(Convert.ToInt32(Session["DNID"]), iCategoryId, 0, Convert.ToInt32(Session["URID"]), ViewBag.R["xfalias"].ToString()
                                        , ViewBag.R.current["operator"].ToString(), "", 1, iCount, "CreateDate", "DESC", "", "", "", "", sCmd);

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.ListProc = svcRt.ResultDataTable;
                    }
                    else
                    {
                        rt = svcRt.ResultMessage;
                        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                    }
                }
            }

            return View();
        }

        // GET: Docs/Kms
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
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
            }

            rt = Resources.Global.Auth_NoPermission;
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
            ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("doc").ToString() : ViewBag.R.lv["count"].ToString();
            ViewBag.R.lv["basesort"] = ViewBag.R.lv["basesort"].ToString() == "" ? "CreateDate" : ViewBag.R.lv["basesort"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "CreateDate" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.KnowledgeBiz kb = new BSL.ServiceBiz.KnowledgeBiz())
            {
                svcRt = kb.GetKnowledgeList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R["xfalias"].ToString(), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString(), "tree");
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataTable;
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
                            svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                            sPos = "310";
                            ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                            ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                        }
                    }

                    if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "V")))
                    {
                        return Resources.Global.Auth_NoPermission;
                    }

                    sPos = "400";
                    using (ZumNet.BSL.ServiceBiz.KnowledgeBiz kb = new BSL.ServiceBiz.KnowledgeBiz())
                    {
                        svcRt = kb.GetKnowledgeList(Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R["xfalias"].ToString()
                                                    , ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                                    , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                                    , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString()
                                                    , jPost["lv"]["searchtext"].ToString(), jPost["lv"]["start"].ToString(), jPost["lv"]["end"].ToString(), "tree");
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";

                        ViewBag.BoardList = svcRt.ResultDataTable;
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
                catch (Exception ex)
                {
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }
            return rt;
        }
        #endregion

        #region [게시물 작성, 조회]
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
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(Session["DNID"]), iCategoryId, Convert.ToInt32(Session["URID"]), iFolderId, "O", "0");

                    ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "R") || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R")))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.KnowledgeBiz kb = new BSL.ServiceBiz.KnowledgeBiz())
            {
                svcRt = kb.GetKmsView(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DNID"]), iCategoryId, iFolderId, iAppId.ToString(), ViewBag.R.xfalias.ToString());
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
        #endregion
    }
}