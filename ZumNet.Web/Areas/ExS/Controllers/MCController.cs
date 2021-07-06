using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.ExS.Controllers
{
    public class MCController : Controller
    {
        // GET: ExS/MC
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }
    }
}