using System;
using System.Configuration;
using System.Threading;
using System.Web;
using System.Web.Mvc;

namespace ZumNet.Web.Filter
{
    public class CultureFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            string culture = null;

            HttpCookie ck = filterContext.HttpContext.Request.Cookies["locale"];
            if (ck != null)
            {
                culture = ck.Value;
            }

            if (culture == "")
            {
                if (filterContext.HttpContext.Request.UserLanguages != null)
                {
                    culture = filterContext.HttpContext.Request.UserLanguages[0];
                }
                else
                {
                    culture = ConfigurationManager.AppSettings["DefaultLocale"];  //"ko-KR";    

                }
            }

            if (culture != null && culture.Trim() != "")
            {
                Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);
                Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;
            }
            ZumNet.Framework.Log.Logging.WriteDebug(HttpContext.Current.Request.CurrentExecutionFilePath + " => " + DateTime.Now.ToString() + " : " + culture + Environment.NewLine);
        }
    }
}