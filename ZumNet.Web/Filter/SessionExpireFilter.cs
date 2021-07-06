using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace ZumNet.Web.Filter
{
    public class SessionExpireFilter : ActionFilterAttribute, IActionFilter
    {
        void IActionFilter.OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;

            // check if session is supported
            if (ctx.Session != null)
            {
                // check if a new session id was generated
                if (ctx.Session.IsNewSession)
                {
                    // If it says it is a new session, but an existing cookie exists, then it must have timed out
                    string sessionCookie = ctx.Request.Headers["Cookie"];
                    if (sessionCookie != null && sessionCookie.IndexOf("ASP.NET_SessionId") >= 0)
                    {
                        if (ctx.Request.IsAuthenticated)
                        {
                            FormsAuthentication.SignOut();
                        }

                        string redirectOnSuccess = filterContext.HttpContext.Request.Url.PathAndQuery;

                        //2018-12-13 
                        if (redirectOnSuccess.Length > 0) redirectOnSuccess = HttpContext.Current.Server.UrlEncode(redirectOnSuccess);

                        string redirectUrl = string.Format("?returnUrl={0}", redirectOnSuccess);
                        string loginUrl = FormsAuthentication.LoginUrl + redirectUrl;

                        if (filterContext.HttpContext.Request.IsAjaxRequest())
                        {
                            filterContext.HttpContext.Response.StatusCode = 403;
                            filterContext.Result = new JsonResult { Data = loginUrl };
                        }
                        else
                        {
                            filterContext.Result = new RedirectResult(loginUrl);
                            //ctx.Response.Redirect("~/Home/Logon");
                            //ctx.Response.Redirect(loginUrl, true);
                        }
                    }
                }
            }

            OnActionExecuting(filterContext);
        }
    }
}