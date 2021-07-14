using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

using ZumNet.Web.Bc;
using ZumNet.Web.Models;

namespace ZumNet.Web.Controllers
{
    public class AccountController : Controller
    {
        /// <summary>
        /// 로그인 페이지
        /// </summary>
        [AllowAnonymous]
        [OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        /// <summary>
        /// 인증
        /// </summary>
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(AccountViewModels model, string returnUrl)
        {
            AuthManager auth = new AuthManager();
            string strDesc = "";

            string result = auth.AuthenticateUser(model.LoginId, model.Password);
            if (result == "OK")
            {
                string sEncrypt = ZumNet.Framework.Util.SecurityHelper.AESEncryp(model.Password);
                result = auth.SessionStart(model.LoginId, sEncrypt);
            }

            if (result == "OK")
            {
                FormsAuthentication.SetAuthCookie(model.LoginId, false); //세션값이 정상 생성되면 인증권한을 준다.
                return RedirectToLocal(returnUrl);
            }
            else if (result == "PWC")
            {
                FormsAuthentication.SetAuthCookie(model.LoginId, false); //세션값이 정상 생성되면 인증권한을 준다.
                return RedirectToAction("PWChange", "Account");
            }
            else
            {
                if (result == "NOUSER") strDesc = Resources.Global.msg_Auth_NOUSER; //"사용자 정보가 없습니다.";
                else if (result == "FAIL") strDesc = Resources.Global.msg_Auth_FAIL; //"아이디나 암호가 틀렸거나 잘못된 경로로 접근했습니다.";
                else if (result == "SYSDOWN") strDesc = Resources.Global.msg_Auth_SYSDOWN; //"서비스가 정지 되었습니다. 관리자에게 문의하세요";
                else if (result == "NOACT") strDesc = Resources.Global.msg_Auth_NOACT; //"사용이 일시 정지 되었습니다. 관리자에게 문의하세요.";
                else if (result == "DBLACCOUNT") strDesc = Resources.Global.msg_Auth_DBLACCOUNT; //"계정이 하나 이상 존재 합니다. 관리자에게 문의 바랍니다.";
                //else if (result == "NODB") strDesc = "존재하지 않는 아이디 이거나 사용 중지된 아이디 입니다.";
                else strDesc = Resources.Global.msg_Auth_FAULT; //"잘못된 로그인 시도입니다.";

                ModelState.AddModelError("", strDesc);
                return View(model);
            }
        }

        /// <summary>
        /// 로그 아웃
        /// </summary>
        /// <param name="model"></param>
        /// <param name="returnUrl"></param>
        /// <returns></returns>
        public ActionResult Logout(AccountViewModels model, string returnUrl)
        {
            FormsAuthentication.SignOut();
            foreach (var cookie in Request.Cookies.AllKeys)
            {
                Request.Cookies.Remove(cookie);
            }

            Session.Clear();

            return RedirectToLocal("/Account/Login?returnUrl=" + returnUrl);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="returnUrl"></param>
        /// <returns></returns>
        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Portal");
        }
    }
}