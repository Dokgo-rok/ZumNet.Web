using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.Docs.Controllers
{
    public class KmsController : Controller
    {
        // GET: Docs/Kms
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }
    }
}