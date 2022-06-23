using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Controllers
{
    public class OrganController : Controller
    {
        // GET: Organ
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

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
            {
                svcRt = op.GetOrgMapInfo(Convert.ToInt32(Session["DNID"]), 0, "D", Convert.ToInt32(Session["DeptID"]), DateTime.Now.ToString("yyyy-MM-dd"), "N");

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    //ViewBag.OrgTree = svcRt.ResultDataRowCollection;
                    //ViewBag.TreeOpenNode = svcRt.ResultDataDetail["openNode"];

                    ViewBag.R.tree = CtrlHandler.OrgTree(svcRt);
                }
                else
                {
                    //에러페이지
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                svcRt = null;

                ViewBag.R.lv["page"] = ViewBag.R.lv["page"].ToString() == "" || ViewBag.R.lv["page"].ToString() == "0" ? "1" : ViewBag.R.lv["page"].ToString();
                ViewBag.R.lv["count"] = ViewBag.R.lv["count"].ToString() == "" || ViewBag.R.lv["count"].ToString() == "0" ? Bc.CommonUtils.GetLvCookie("orgmap").ToString() : ViewBag.R.lv["count"].ToString();
                ViewBag.R["opnode"] = "7777." + Session["DeptID"].ToString();
                ViewBag.R.lv["tgt"] = Session["DeptID"].ToString();

                rt = Bc.CtrlHandler.SiteMap(this, 0, 0, ViewBag.R["opnode"].ToString());
                if (rt != "")
                {
                    rt = svcRt.ResultMessage;
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }

                //조직도 부서 클릭 경우만 세션 끊긴 후 고려, 검색은 제외
                svcRt = op.GetDeptGroupList(StringHelper.SafeInt(Session["DNID"].ToString()), Convert.ToInt32(ViewBag.R.lv.page.Value)
                                        , Convert.ToInt32(ViewBag.R.lv.count.Value), "", "", "", " AND GR_ID = " + Session["DeptID"].ToString());

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.MemberList = svcRt.ResultDataRowCollection;
                    //ViewBag.MemberCount = svcRt.ResultItemCount.ToString();
                    ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
                }
                else
                {
                    //에러페이지
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                svcRt = cb.GetGradeCode("1", Convert.ToInt32(Session["DNID"]), "A");

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.GradeCode = svcRt.ResultDataRowCollection;
                }
                else
                {
                    //에러페이지
                    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(svcRt.ResultMessage), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
                }
            }

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Index(string Qi)
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    JObject jV;

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "필수값 누락!";
                    }

                    sPos = "100";
                    using (StreamReader reader = System.IO.File.OpenText(Server.MapPath("~/Content/Json/init.json")))
                    {
                        jV = (JObject)JToken.ReadFrom(reader: new JsonTextReader(reader));
                    }

                    sPos = "200";
                    string sMode = StringHelper.SafeString(jPost["M"]); //all : 전체 검색
                    string sSearchText = "";
                    StringBuilder sbSearch = new StringBuilder();

                    if (sMode == "all")
                    {
                        sSearchText = " AND (Role = 'regular' OR Role = 'chief') AND Grade1 IS NOT NULL";
                    }
                    else
                    {
                        if (StringHelper.SafeInt(jPost["tgt"]) > 0)
                        {
                            sbSearch.AppendFormat(" AND GR_ID = {0}", jPost["tgt"].ToString());
                        }
                        else
                        {
                            if (StringHelper.SafeString(jPost["ur"]) != "") sbSearch.AppendFormat(" AND DisplayName LIKE '%{0}%'", jPost["ur"].ToString());
                            if (StringHelper.SafeString(jPost["urcn"]) != "") sbSearch.AppendFormat(" AND LogonID LIKE '%{0}%'", jPost["urcn"].ToString());
                            if (StringHelper.SafeString(jPost["dept"]) != "") sbSearch.AppendFormat(" AND GroupName LIKE '%{0}%'", jPost["dept"].ToString());
                            if (StringHelper.SafeString(jPost["grade"]) != "") sbSearch.AppendFormat(" AND Code1 = '{0}'", jPost["grade"].ToString());
                        }

                        sSearchText = sbSearch.ToString();
                    }

                    sPos = "300";
                    using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                    {
                        svcRt = op.GetDeptGroupList(StringHelper.SafeInt(Session["DNID"].ToString()), Convert.ToInt32(jPost["page"]), Convert.ToInt32(jPost["count"]), "", "", "", sSearchText);
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "400";
                        jV["lv"]["tgt"] = StringHelper.SafeString(jPost["tgt"]);
                        jV["lv"]["page"] = StringHelper.SafeString(jPost["page"]);
                        jV["lv"]["count"] = StringHelper.SafeString(jPost["count"]);
                        jV["lv"]["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "410";
                        ViewBag.MemberList = svcRt.ResultDataRowCollection;
                        ViewBag.R = jV;

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_MemberList", ViewBag.MemberList)
                                + jPost["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListCount.cshtml", ViewBag)
                                + jPost["boundary"].ToString()
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
        [HttpPost]
        [Authorize]
        public string PersonSimpleInfo(int id)
        {
            string strView = "";
            if (Request.IsAjaxRequest())
            {
                if (id == 0)
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                {
                    svcRt = op.GetUserPersonalInfo(id);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.PersonInfo = svcRt.ResultDataSet;

                    strView = "OK" + RazorViewToString.RenderRazorViewToString(this, "_PersonSimpleInfo", ViewBag.MemberList);
                }
                else
                {
                    //에러페이지
                    strView = svcRt.ResultMessage;
                }
            }
            return strView;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Plate()
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    string sOrgTree = "";

                    if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "") //user, group, all
                    {
                        return "필수값 누락!";
                    }

                    if (jPost["M"].ToString() == "__group")
                    {
                        using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                        {
                            sPos = "100";
                            svcRt = op.GetOrgMapInfo(Convert.ToInt32(Session["DNID"]), 0, "D", Convert.ToInt32(Session["DeptID"]), DateTime.Now.ToString("yyyy-MM-dd"), "N");

                            if (rt == "" && svcRt != null && svcRt.ResultCode == 0)
                            {
                                sPos = "110";
                                sOrgTree = CtrlHandler.OrgTreeString(svcRt);
                                ViewBag.JPost = jPost;

                                sPos = "120";
                                rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Plate", ViewBag)
                                        + jPost["boundary"].ToString() + sOrgTree;
                            }
                            else
                            {
                                //에러페이지
                                rt = "[" + sPos + "] " + svcRt.ResultMessage;
                            }
                        }
                    }
                    else if (jPost["M"].ToString() == "user" || jPost["M"].ToString() == "group" || jPost["M"].ToString() == "all")
                    {
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            sPos = "200";
                            svcRt = cb.GetGradeCode("1", Convert.ToInt32(Session["DNID"]), "A");
                            if (svcRt != null && svcRt.ResultCode == 0) ViewBag.GradeCode = svcRt.ResultDataRowCollection;
                            else rt = "[" + sPos + "] " + svcRt.ResultMessage;
                        }

                        if (rt == "")
                        {
                            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                            {
                                sPos = "210";
                                svcRt = op.GetOrgMapInfo(Convert.ToInt32(Session["DNID"]), 0, "D", Convert.ToInt32(Session["DeptID"]), DateTime.Now.ToString("yyyy-MM-dd"), "N");

                                if (svcRt != null && svcRt.ResultCode == 0) sOrgTree = CtrlHandler.OrgTreeString(svcRt);
                                else rt = "[" + sPos + "] " + svcRt.ResultMessage;

                                if (rt == "")
                                {
                                    sPos = "220";
                                    svcRt = op.GetGroupMemberList(Session["DNID"].ToString(), Session["DeptID"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"), "Code1", "", Session["Admin"].ToString());

                                    if (svcRt != null && svcRt.ResultCode == 0) ViewBag.MemberList = svcRt.ResultDataSet;
                                    else rt = "[" + sPos + "] " + svcRt.ResultMessage;

                                }
                            }

                            if (rt == "")
                            {
                                sPos = "230";
                                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                                {
                                    svcRt = cb.GetMemberStates(Convert.ToInt32(Session["URID"]), Convert.ToInt32(Session["DeptID"]));
                                }

                                if (svcRt != null && svcRt.ResultCode == 0)
                                {
                                    sPos = "240";
                                    ViewBag.UserInfo = svcRt.ResultDataSet;
                                    ViewBag.JPost = jPost;

                                    sPos = "250";
                                    rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Plate", ViewBag)
                                            + jPost["boundary"].ToString() + sOrgTree;
                                }
                                else
                                {
                                    //에러페이지
                                    rt = "[" + sPos + "] " + svcRt.ResultMessage;
                                }
                            }
                        }
                    }
                    else if (jPost["M"].ToString() == "userinfo")
                    {
                        if (jPost["urid"].ToString() == "" || jPost["grid"].ToString() == "") return "필수값 누락!";

                        sPos = "300";
                        using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                        {
                            svcRt = cb.GetMemberStates(Convert.ToInt32(jPost["urid"]), Convert.ToInt32(jPost["grid"]));
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            sPos = "310";
                            ViewBag.UserInfo = svcRt.ResultDataSet;
                            ViewBag.JPost = jPost;

                            sPos = "320";
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Plate", ViewBag);
                        }
                        else
                        {
                            //에러페이지
                            rt = "[" + sPos + "] " + svcRt.ResultMessage;
                        }
                    }
                    else
                    {
                        if (jPost["M"].ToString() == "search")
                        {
                            if (jPost["ur"].ToString() == "" && jPost["urcn"].ToString() == "" && jPost["dept"].ToString() == "" && jPost["grade"].ToString() == "") return "필수값 누락!";

                            sPos = "900";
                            StringBuilder sbSearch = new StringBuilder();
                            if (StringHelper.SafeString(jPost["ur"]) != "") sbSearch.AppendFormat(" AND DisplayName LIKE '%{0}%'", jPost["ur"].ToString());
                            if (StringHelper.SafeString(jPost["urcn"]) != "") sbSearch.AppendFormat(" AND LogonID LIKE '%{0}%'", jPost["urcn"].ToString());
                            if (StringHelper.SafeString(jPost["dept"]) != "") sbSearch.AppendFormat(" AND GroupName LIKE '%{0}%'", jPost["dept"].ToString());
                            if (StringHelper.SafeString(jPost["grade"]) != "") sbSearch.AppendFormat(" AND Code1 = '{0}'", jPost["grade"].ToString());

                            sPos = "910";
                            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                            {
                                svcRt = op.GetDeptGroupList(StringHelper.SafeInt(Session["DNID"].ToString()), 1, 1000, "", "", "", sbSearch.ToString());
                            }
                        }
                        else if (jPost["M"].ToString() == "userinfo")
                        {
                            if (jPost["urid"].ToString() == "" || jPost["grid"].ToString() == "") return "필수값 누락!";

                            sPos = "920";
                            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                            {
                                svcRt = cb.GetMemberStates(Convert.ToInt32(jPost["urid"]), Convert.ToInt32(jPost["grid"]));
                            }
                        }
                        else
                        {
                            if (jPost["grid"].ToString() == "")  return "필수값 누락!";

                            sPos = "930";
                            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                            {
                                svcRt = op.GetGroupMemberList(Session["DNID"].ToString(), jPost["grid"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"), "Code1", "", Session["Admin"].ToString());
                            }
                        }

                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            sPos = "990";
                            ViewBag.MemberList = svcRt.ResultDataSet;
                            ViewBag.JPost = jPost;

                            sPos = "991";
                            rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_Plate", ViewBag);
                        }
                        else
                        {
                            //에러페이지
                            rt = "[" + sPos + "] " + svcRt.ResultMessage;
                        }
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