using Microsoft.Ajax.Utilities;
using System;
using System.Configuration;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using ZumNet.Web.Bc;

namespace ZumNet.Web.Filter
{
    public class CultureFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            //HttpCookie ck = filterContext.HttpContext.Request.Cookies["locale"];
            //if (ck != null)
            //{
            //    culture = ck.Value;
            //}

            string culture = CommonUtils.GetCookie("locale"); //24-12-12 쿠키 불러오기 변경

            if (String.IsNullOrWhiteSpace(culture))
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

            if (!String.IsNullOrWhiteSpace(culture))
            {
                //24-12-12 조건문 추가
                if (culture.Contains("ko")) culture = "ko-KR";
                else if (culture.Contains("en")) culture = "en-US";
                else if (culture.Contains("zh")) culture = "zh-CN";
                else if (culture.Contains("ja")) culture = "ja-JP";
                else culture = "en-US";

                Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);
                Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;

                CommonUtils.SetCookie("locale", culture); //24-12-12 추가
            }
            //ZumNet.Framework.Log.Logging.WriteDebug(HttpContext.Current.Request.CurrentExecutionFilePath + " => " + DateTime.Now.ToString() + " : " + culture + Environment.NewLine);
        }
    }
}