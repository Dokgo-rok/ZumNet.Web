using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.TnC.Controllers
{
    public class ToDoController : Controller
    {
        // GET: TnC/ToDo
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }
    }
}