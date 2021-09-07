using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ZumNet.BSL.FlowBiz;
using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Web;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class ProcController : Controller
    {
        // GET: WoA/Proc
        public ActionResult Index()
        {
            int domainID = StringHelper.SafeInt(Session["DNID"].ToString());

            using (EApprovalBiz eApprovalBiz = new EApprovalBiz())
            {
                // 프로세스 조회
                ServiceResult result = eApprovalBiz.SelectProcessListByCondition(domainID, 0, "Y");

                ViewData["processListJson"] = JsonConvert.SerializeObject(result.ResultDataTable);
            }

            return View();
        }
    }
}