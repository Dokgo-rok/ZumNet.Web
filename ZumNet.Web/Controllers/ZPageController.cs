using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Controllers
{
    public class ZPageController : Controller
    {
        // GET: ZPage
        public ActionResult Approval()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Approval_form()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Approval_item()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Approval2()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Board()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Docu()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult Organization_chart()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }

        public ActionResult UI()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);

            return View();
        }
    }
}