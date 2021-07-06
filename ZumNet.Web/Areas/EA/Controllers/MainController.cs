using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.EA.Controllers
{
    public class MainController : Controller
    {
        // GET: EA/Main
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }
    }
}