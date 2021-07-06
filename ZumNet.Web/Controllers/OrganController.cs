using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
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
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            string rt = Bc.CtrlHandler.PageInit(this, false);

            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
            {
                svcRt = op.GetOrgMapInfo(Convert.ToInt32(Session["DNID"]), 0, "D", Convert.ToInt32(Session["DeptID"]), DateTime.Now.ToString("yyyy-MM-dd"), "N");

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.OrgTree = svcRt.ResultDataRowCollection;
                    ViewBag.TreeOpenNode = svcRt.ResultDataDetail["openNode"];
                }
                else
                {
                    //에러페이지
                }

                svcRt = null;

                svcRt = op.GetDeptGroupList(Session["DNID"].ToString(), 1, 50, "", "", "", " AND GR_ID = " + Session["DeptID"].ToString());

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.MemberList = svcRt.ResultDataRowCollection;
                    ViewBag.MemberCount = svcRt.ResultItemCount.ToString();
                }
                else
                {
                    //에러페이지
                }
            }

            svcRt = null;

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Index(string Qi)
        {
            string strView = "";
            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
                {
                    svcRt = op.GetDeptGroupList(Session["DNID"].ToString(), Convert.ToInt32(jPost["page"]), Convert.ToInt32(jPost["count"]), "", "", "", " AND GR_ID = " + jPost["tgt"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ViewBag.MemberList = svcRt.ResultDataRowCollection;
                    ViewBag.MemberCount = svcRt.ResultItemCount.ToString();

                    strView = "OK" + RazorViewToString.RenderRazorViewToString(this, "_MemberList", ViewBag.MemberList);
                }
                else
                {
                    //에러페이지
                    strView = svcRt.ResultMessage;
                }
            }
            return strView;
        }
    }
}