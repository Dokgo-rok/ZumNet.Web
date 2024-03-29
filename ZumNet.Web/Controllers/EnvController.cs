using System;
using System.Collections.Generic;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Util;
using ZumNet.BSL.ServiceBiz;
using ZumNet.BSL.FlowBiz;
using System.Web.UI.WebControls;
using System.Data;
using System.Reflection;
using ZumNet.Framework.Exception;

namespace ZumNet.Web.Controllers
{
    public class EnvController : Controller
    {
        /// <summary>
        /// 개인정보 환경설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Index()
        {
            string rt = Bc.CtrlHandler.PageInit(this, false);
            if (rt != "")
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }

            return View();
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SavePersonInfo()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["UserID"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (OfficePortalBiz opBiz = new OfficePortalBiz())
                    {
                        svcRt = opBiz.SetPersonInfo(jPost);
                    }

                    if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                    else rt = "OK";
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SavePersonAbsent()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0 || jPost["UserID"].ToString() == "") return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (OfficePortalBiz opBiz = new OfficePortalBiz())
                    {
                        svcRt = opBiz.SetPersonInfo(jPost, "absent");
                    }

                    string sMode = jPost["UseDeputy"].ToString() == "Y" && jPost["Deputy"].ToString() != "" ? "1" : "";
                    {
                        using (WorkList wk = new WorkList())
                        {
                            svcRt = wk.SetDeputyParticipant(sMode, StringHelper.SafeInt(jPost["UserID"].ToString()), jPost["Deputy"].ToString(), jPost["DeputyDeptCode"].ToString(), 0, "");
                        }
                    }

                    if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                    else rt = "OK";
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string PwdChange()
        {
            string rt = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "100";
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0) return "필수값 누락!";

                    if (Session["LogonPwd"] != null)
                    {
                        sPos = "200";
                        if (SecurityHelper.AESDecrypt(Session["LogonPwd"].ToString()) == jPost["cur"].ToString())
                        {
                            ZumNet.Framework.Core.ServiceResult svcRt = null;
                            
                            string strPasswordEncrypt = SecurityHelper.AESEncrypt(jPost["new"].ToString());
                            string sAuthType = Framework.Configuration.Config.Read("AuthType");

                            sPos = "300";
                            //if (sAuthType == "DB")
                            //{
                            //DB 암호 변경
                            using (CommonBiz comBiz = new CommonBiz())
                            {
                                svcRt = comBiz.SetPasswordChange(jPost["urid"].ToString(), strPasswordEncrypt);

                                if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                                else rt = "OK";
                            }
                            //}

                            if (rt == "OK")
                            {
                                //EKP 암호 변경
                                if (sAuthType == "AD")
                                {
                                    sPos = "400";

                                    //AD 암호 변경
                                    using (ZumNet.Framework.AD.ADHandler ad = new Framework.AD.ADHandler(Framework.Configuration.Config.Read("DomainName"), "", Framework.Configuration.Config.Read("SysAdmin")
                                        , SecurityHelper.AESDecrypt(Framework.Configuration.ConfigINI.GetValue(Framework.Configuration.Sections.SECTION_ROOT, Framework.Configuration.Property.INIKEY_ROOT_SA1))))
                                    {
                                        sPos = "410";
                                        rt = ad.ChangePassword(jPost["logonid"].ToString(), jPost["cur"].ToString(), jPost["new"].ToString());
                                    }
                                    if (rt != "OK") rt = "비밀번호가 일치하지 않습니다!";
                                }

                                //ERP 암호 변경

                                if (Session["IsESP"].ToString() == "Y")
                                {
                                    sPos = "500";

                                    //구매포탈 암호 변경
                                    string strQuery = @"UPDATE ZWESP.dbo.SVC_USR WITH (ROWLOCK) SET pwd = @pwd, pwdmod = GETDATE() WHERE logonid = @logonid";

                                    System.Data.SqlClient.SqlParameter[] parameters = new System.Data.SqlClient.SqlParameter[]
                                    {
                                        Framework.Data.ParamSet.Add4Sql("@logonid", SqlDbType.VarChar, 50, jPost["logonid"].ToString()),
                                        Framework.Data.ParamSet.Add4Sql("@pwd", SqlDbType.VarChar, 100, strPasswordEncrypt)
                                    };

                                    using (ZumNet.BSL.InterfaceBiz.ExecuteBiz execBiz = new BSL.InterfaceBiz.ExecuteBiz())
                                    {
                                        svcRt = execBiz.ExecuteQueryTx(strQuery, 15, parameters);
                                    }

                                    if (svcRt.ResultCode != 0) rt += svcRt.ResultMessage; //OK+오류메시지
                                }                                
                            }
                        }
                        else
                        {
                            rt = "비밀번호가 일치하지 않습니다!";
                        }
                    }
                    else rt = "비밀번호 확인 실패!";
                }
                catch (Exception ex)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, MethodBase.GetCurrentMethod().Name, sPos);
                    rt = "[" + sPos + "] " + ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string UseEAPassword()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0) return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (WorkList wk = new WorkList())
                    {
                        svcRt = wk.SetEApprovalPassword(Convert.ToInt32(jPost["urid"]), jPost["usepwd"].ToString());
                    }

                    if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                    else rt = "OK";
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string EAPwdChange()
        {
            string rt = "";
            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0) return "필수값 누락!";

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (WorkList wk = new WorkList())
                    {
                        svcRt = wk.ChangeApprovalPassword("", Convert.ToInt32(jPost["urid"]), jPost["cur"].ToString(), jPost["new"].ToString());
                    }

                    if (svcRt.ResultCode != 0) rt = svcRt.ResultMessage;
                    else rt = svcRt.ResultDataString;
                }
                catch (Exception ex)
                {
                    rt = ex.Message;
                }
            }
            return rt;
        }
    }
}