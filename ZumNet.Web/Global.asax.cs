using System;
using System.Configuration;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using JavaScriptEngineSwitcher.Core;
using ZumNet.Web.App_Start;

namespace ZumNet.Web
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            JsEngineSwitcherConfig.Configure(JsEngineSwitcher.Current);
        }

        private void Application_BeginRequest(Object source, EventArgs e)
        {
            //HttpApplication application = (HttpApplication)source;
            //HttpContext ctx = application.Context;

            //string culture = null;

            //HttpCookie ck = ctx.Request.Cookies["locale"];
            //if (ck != null)
            //{
            //    culture = ck.Value;
            //}
            
            //if (culture == "")
            //{
            //    if (ctx.Request.UserLanguages != null)
            //    {
            //        culture = ctx.Request.UserLanguages[0];
            //    }
            //    else
            //    {
            //        culture = ConfigurationManager.AppSettings["DefaultLocale"];  //"ko-KR";    

            //    }
            //}

            //if (culture != null && culture.Trim() != "")
            //{
            //    Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);
            //    Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;
            //}
            //ZumNet.Framework.Log.Logging.WriteDebug(HttpContext.Current.Request.CurrentExecutionFilePath + " => " + DateTime.Now.ToString() + " : " + culture + Environment.NewLine);
        }
    }
}
