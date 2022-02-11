using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class MCController : Controller
    {
        #region [메인, 목록]
        // GET: ExS/MC
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

            int iCategoryId = StringHelper.SafeInt(ViewBag.R.ct.Value);
            ViewBag.R["ft"] = StringHelper.SafeString(ViewBag.R.ft.ToString(), "CostList"); //기존 페이지 설정
            string formTable = ViewBag.R.ft.ToString();

            //권한, 설정 가져오기
            rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            rt = Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
            if (ViewBag.R.current["operator"].ToString() == "N" && (
                    ViewBag.R.current["acl"].ToString() == ""
                    || (formTable.ToLower() == "costlist" && !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "M")) //마킹권한
                    || (formTable.ToLower() == "stdtime" && !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "W")) //쓰기권한
                    || !StringHelper.HasAcl(ViewBag.R.current["acl"].ToString().Substring(0, 6), "S") //그외 페이지 보안권한
                ))
            {
                return View("~/Views/Shared/_NoPermission.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ViewBag.R.lv["page"] = "1";
            ViewBag.R.lv["count"] = StringHelper.SafeString(Bc.CommonUtils.GetLvCookie("cost").ToString(), "7");

            ZumNet.Framework.Core.ServiceResult svcRt = null;
            string sCmd = "";
            
            if (formTable.ToLower() == "costlist" || formTable.ToLower() == "stdtime")
            {
                //초기 설정
                if (StringHelper.SafeInt(ViewBag.R.lv.tgt.Value) == 0) ViewBag.R.lv["tgt"] = Convert.ToInt32(ViewBag.CodeTable["ce.center"][0][6]);
                if (ViewBag.R.lv.start.ToString() == "") ViewBag.R.lv["start"] = DateTime.Now.ToString("yyyyMM");

                if (formTable.ToLower() == "costlist")
                {
                    sCmd = ViewBag.R.mode == "xls" ? "X" : "";
                    ViewBag.R.lv["count"] = "7"; //고정
                }
                else if (formTable.ToLower() == "stdtime") sCmd = ViewBag.R.mode == "xls" ? "E" : "T";
            }

            using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
            {
                if (formTable.ToLower() == "costlist" || formTable.ToLower() == "stdtime")
                {
                    svcRt = cost.GetMCSUMMARY(sCmd, StringHelper.SafeInt(ViewBag.R.lv.tgt.Value), ViewBag.R.lv.start.ToString()
                                , StringHelper.SafeInt(ViewBag.R.lv.page.Value), StringHelper.SafeInt(ViewBag.R.lv.count.Value)
                                , ViewBag.R.lv.sort.ToString(), ViewBag.R.lv.sortdir.ToString(), ViewBag.R.lv.search.ToString(), ViewBag.R.lv.searchtext.ToString()
                                , StringHelper.SafeString(ViewBag.R.lv.cd1), StringHelper.SafeString(ViewBag.R.lv.cd2), StringHelper.SafeString(ViewBag.R.lv.cd3));
                }
                else if (formTable.ToLower() == "__")
                {

                }
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ViewBag.BoardList = svcRt.ResultDataSet;
                ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();
            }
            else
            {
                rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            ViewBag.Mode = ViewBag.R.mode.ToString();

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

                    sPos = "200";
                    int iCategoryId = Convert.ToInt32(jPost["ct"]);
                    string formTable = jPost["ft"].ToString();

                    //권한, 설정 가져오기
                    sPos = "300";
                    rt = Bc.CtrlHandler.CostInit(this, iCategoryId, StringHelper.SafeString(ViewBag.R.ctalias.Value));
                    if (rt != "") return "[" + sPos + "] " + rt;

                    sPos = "310";
                    if (jPost["current"]["operator"].ToString() == "N" && (
                            jPost["current"]["acl"].ToString() == ""
                            || (formTable.ToLower() == "costlist" && !StringHelper.HasAcl(jPost["current"]["acl"].ToString().Substring(0, 6), "M")) //마킹권한
                            || (formTable.ToLower() == "stdtime" && !StringHelper.HasAcl(jPost["current"]["acl"].ToString().Substring(0, 6), "W")) //쓰기권한
                            || !StringHelper.HasAcl(jPost["corrent"]["acl"].ToString().Substring(0, 6), "S") //그외 페이지 보안권한
                        ))
                    {
                        return Resources.Global.Auth_NoPermission; //"권한이 없습니다!!";
                    }

                    if ((jPost["ft"].ToString().ToLower() == "memberplan" || jPost["ft"].ToString().ToLower() == "memberstatus" || jPost["ft"].ToString().ToLower() == "memberrequest") && jPost["current"]["chief"].ToString() != "Y")
                    {
                        return Resources.Global.Auth_NoPermission;
                    }

                    sPos = "400";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    string sCmd = "";

                    if (formTable.ToLower() == "costlist" || formTable.ToLower() == "stdtime")
                    {
                        //초기 설정
                        sPos = "410";
                        if (formTable.ToLower() == "costlist") sCmd = jPost["mode"].ToString() == "xls" ? "X" : "";
                        else if (formTable.ToLower() == "stdtime") sCmd = jPost["mode"].ToString() == "xls" ? "E" : "T";
                    }

                    using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                    {
                        if (formTable.ToLower() == "costlist" || formTable.ToLower() == "stdtime")
                        {
                            sPos = "420";
                            svcRt = cost.GetMCSUMMARY(sCmd, Convert.ToInt32(jPost["lv"]["tgt"]), jPost["lv"]["start"].ToString()
                                        , Convert.ToInt32(jPost["lv"]["page"]), Convert.ToInt32(jPost["lv"]["count"])
                                        , jPost["lv"]["sort"].ToString(), jPost["lv"]["sortdir"].ToString(), jPost["lv"]["search"].ToString(), jPost["lv"]["searchtext"].ToString()
                                        , jPost["lv"]["cd1"].ToString(), jPost["lv"]["cd2"].ToString(), jPost["lv"]["cd3"].ToString());
                        }
                        else if (formTable.ToLower() == "__")
                        {
                            sPos = "430";
                        }
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sPos = "500";
                        ViewBag.Mode = ViewBag.R.mode.ToString();
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.R.lv["total"] = svcRt.ResultItemCount.ToString();

                        sPos = "510";
                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_" + formTable, ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "_ListCount", ViewBag)
                                + jPost["lv"]["boundary"].ToString()
                                + RazorViewToString.RenderRazorViewToString(this, "~/Views/Common/_ListPagination.cshtml", ViewBag);
                    }
                    else
                    {
                        rt = svcRt == null ? "조건에 해당되는 화면 누락" : svcRt.ResultMessage;
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

        #region [상세 조회]
        /// <summary>
        /// 모델별원가 항목 보기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string ListItem()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["cmd"].ToString() == "" || jPost["tgt"].ToString() == ""
                        || jPost["model"].ToString() == "" || jPost["fld"].ToString() == "" || jPost["vd"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                    {
                        svcRt = cost.GetMCSUMMARYITEM(jPost["cmd"].ToString(), Convert.ToInt32(jPost["tgt"]), jPost["vd"].ToString()
                                            , jPost["fld"].ToString(), jPost["model"].ToString(), jPost["item"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_ListItem", ViewBag);
                    }
                    else
                    {
                        //에러페이지
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

        /// <summary>
        /// 모델별공수 항목 보기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string StdTimeDay()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0 || jPost["cmd"].ToString() == "" || jPost["tgt"].ToString() == "" || jPost["model"].ToString() == "" || jPost["vd"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                    {
                        svcRt = cost.GetMCSTDTIME(jPost["cmd"].ToString(), Convert.ToInt32(jPost["tgt"]), jPost["model"].ToString(), jPost["vd"].ToString());
                    }

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ViewBag.BoardList = svcRt.ResultDataSet;
                        ViewBag.JPost = jPost;

                        rt = "OK" + RazorViewToString.RenderRazorViewToString(this, "_StdTimeDay", ViewBag);
                    }
                    else
                    {
                        //에러페이지
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