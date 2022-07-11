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
        #region [게시물 목록]
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

            rt = Resources.Global.Auth_InvalidPath;
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
            ViewBag.R.lv["basesort"] = ViewBag.R.lv["basesort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["basesort"].ToString();
            ViewBag.R.lv["sort"] = ViewBag.R.lv["sort"].ToString() == "" ? "SeqID" : ViewBag.R.lv["sort"].ToString();
            ViewBag.R.lv["sortdir"] = ViewBag.R.lv["sortdir"].ToString() == "" ? "DESC" : ViewBag.R.lv["sortdir"].ToString();

            using (ZumNet.BSL.ServiceBiz.DocBiz db = new BSL.ServiceBiz.DocBiz())
            {
                svcRt = db.GetDocumentMessageList(Convert.ToInt32(Session["DNID"]), iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
                                        , Convert.ToInt32(ViewBag.R.lv.page.Value), Convert.ToInt32(ViewBag.R.lv.count.Value), ViewBag.R.lv["sort"].ToString(), ViewBag.R.lv["sortdir"].ToString()
                                        , ViewBag.R.lv["search"].ToString(), ViewBag.R.lv["searchtext"].ToString(), ViewBag.R.lv["start"].ToString(), ViewBag.R.lv["end"].ToString());
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
                    using (ZumNet.BSL.ServiceBiz.DocBiz db = new BSL.ServiceBiz.DocBiz())
                    {
                        svcRt = db.GetDocumentMessageList(Convert.ToInt32(Session["DNID"]), iFolderId, Convert.ToInt32(Session["URID"]), ViewBag.R.current["operator"].ToString(), ViewBag.R.current.acl.ToString()
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
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
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
                    ViewBag.R.current["acl"] = iFolderId > 0 ? svcRt.ResultDataDetail["acl"].ToString() : "____RV_____RV";
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
            }

            bool bOwner = ViewBag.R.current["urid"].ToString() == Session["URID"].ToString() ? true : false;

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (!bOwner && ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["appacl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "R")))
            {
                return View("~/Views/Shared/_NoPermissionPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.DocBiz docBiz = new BSL.ServiceBiz.DocBiz())
            {
                svcRt = docBiz.GetDocProperty(Convert.ToInt32(Session["DNID"]), iFolderId, Convert.ToInt32(Session["URID"]), iAppId, "0", ViewBag.R.xfalias.ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                rt = FormHandler.BindDocToJson(this, svcRt);
                if (rt != "") return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult Write(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null)
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            if (ViewBag.R.ct.Value == "" || ViewBag.R.ct.Value == "0") ViewBag.R["ct"] = 108;
            int iCategoryId = Convert.ToInt32(ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ViewBag.R.fdid.Value);
            string sObjectType = iFolderId == 0 ? "" : "O";

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
                    ViewBag.R.current["acl"] = iFolderId > 0 ? svcRt.ResultDataDetail["acl"].ToString() : "____RV_____RV";
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
            }

            if (iFolderId > 0)
            {
                rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                if (ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["acl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["acl"].ToString(), "W")))
                {
                    return View("~/Views/Shared/_NoPermissionPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
                if (rt != "")
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            using (ZumNet.BSL.ServiceBiz.DocBiz docBiz = new BSL.ServiceBiz.DocBiz())
            {
                svcRt = docBiz.GetDocLevelKeepYear(Convert.ToInt32(Session["DNID"]));
                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.DocLevel = svcRt.ResultDataDetail["DocLevel"];
                    ViewBag.KeepYear = svcRt.ResultDataDetail["KeepYear"];
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            rt = FormHandler.BindDocToJson(this, null);
            if (rt != "") return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));

            return View();
        }

        [SessionExpireFilter]
        [Authorize]
        public ActionResult Edit(string Qi)
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_InvalidPath; //"잘못된 경로로 접근했습니다!!";
            if (ViewBag.R == null || ViewBag.R.ct == null || ViewBag.R.ct.ToString() == "0")
            {
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
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
                    ViewBag.R.current["acl"] = iFolderId > 0 ? svcRt.ResultDataDetail["acl"].ToString() : "____RV_____RV";
                    if (ViewBag.R.current["appacl"].ToString() == "") ViewBag.R.current["appacl"] = ViewBag.R.current["acl"].ToString().Substring(6, 4) + ViewBag.R.current["acl"].ToString().Substring(ViewBag.R.current["acl"].ToString().Length - 2);
                }
            }

            bool bOwner = ViewBag.R.current["urid"].ToString() == Session["URID"].ToString() ? true : false;

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (!bOwner && ViewBag.R.current["operator"].ToString() == "N" && (ViewBag.R.current["appacl"].ToString() == "" || !ZumNet.Framework.Util.StringHelper.HasAcl(ViewBag.R.current["appacl"].ToString(), "E")))
            {
                return View("~/Views/Shared/_NoPermissionPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Bc.CtrlHandler.SiteMap(this, iCategoryId, iFolderId, ViewBag.R["opnode"].ToString());
            if (rt != "")
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            using (ZumNet.BSL.ServiceBiz.DocBiz docBiz = new BSL.ServiceBiz.DocBiz())
            {
                svcRt = docBiz.GetDocLevelKeepYear(Convert.ToInt32(Session["DNID"]));
                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.DocLevel = svcRt.ResultDataDetail["DocLevel"];
                    ViewBag.KeepYear = svcRt.ResultDataDetail["KeepYear"];
                }
                else
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                svcRt = docBiz.GetDocProperty(Convert.ToInt32(Session["DNID"]), iFolderId, Convert.ToInt32(Session["URID"]), iAppId, "0", ViewBag.R.xfalias.ToString());
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                rt = FormHandler.BindDocToJson(this, svcRt);
                if (rt != "") return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
            else
            {
                rt = svcRt.ResultMessage;
                return View("~/Views/Shared/_ErrorPopup.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }
        #endregion

        #region [게시물 등록]
        /// <summary>
        /// 게시물 등록
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Send()
        {
            string strView = "";
            string strMsg = "등록 하였습니다";

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

                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), jPost["xfalias"].ToString(), (JArray)jPost["attachlist"], null, null);
                    if (svcRt.ResultCode != 0)
                    {
                        strView = svcRt.ResultMessage;
                    }
                    else
                    {
                        jPost["attachlist"] = (JArray)svcRt.ResultDataDetail["FileInfo"];
                    }

                    //jPost["attachxml"] = attachHdr.ConvertFileInfoToXml((JArray)jPost["attachlist"]);
                    //권한정보 -> xml 변환
                    string sAclInfo = "";

                    using (ZumNet.BSL.ServiceBiz.DocBiz docBiz = new BSL.ServiceBiz.DocBiz())
                    {
                        svcRt = docBiz.SetDocMessage(Convert.ToInt32(Session["DNID"]), jPost, sAclInfo);
                    }

                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else strView = "OK" + strMsg;
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