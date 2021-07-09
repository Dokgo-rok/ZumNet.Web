using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.WoA.Controllers
{
    public class AppController : Controller
    {
        // GET: WoA/App
        public ActionResult Index()
        {
            return View();
        }
    }
}