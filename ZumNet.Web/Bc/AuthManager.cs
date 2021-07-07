using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;

using ZumNet.Framework.Util;
using ZumNet.BSL.ServiceBiz;

namespace ZumNet.Web.Bc
{
    public class AuthManager
    {
        public AuthManager() { }

        /// <summary>
        /// 로그인 암호 비교
        /// </summary>
        /// <param name="loginId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public string AuthenticateUser(string loginId, string password)
        {
            string strReturn = "";
            string strPassword = "";

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            using (OfficePortalBiz opBiz = new OfficePortalBiz())
            {
                svcRt = opBiz.GetUserPassword(loginId);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                strPassword = svcRt.ResultDataDetail["password"].ToString();
            }
            else
            {
                //에러페이지
                return svcRt.ResultMessage;
            }

            //보안상 계정이 없거나 비밀번호가 틀린 경우를 구분하면 안됨!!
            if (strPassword == "" || strPassword == "NO USER")
            {
                strReturn = "FAIL";  //"NOUSER";
            }
            else
            {
                //strPassword = SecurityHelper.SetDecrypt(strPassword);
                //strPassword = SecurityHelper.AESDecryp(strPassword);

                if (strPassword == password)
                {
                    strReturn = "OK";
                }
                else
                {
                    strReturn = "FAIL";
                }
                strReturn = "OK";
            }

            return strReturn;
        }

        /// <summary>
        /// 세션설정
        /// </summary>
        /// <param name="loginId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public string SessionStart(string loginId, string password)
        {
            string strReturn = "NODB";
            string strRootOrgid = "";
            string strPwdChange = "N";

            //기존 세션이 남아있는 경우 Session 정보를 제거함
            if (HttpContext.Current.Session != null)
            {
                FormsAuthentication.SignOut();
                foreach (var cookie in HttpContext.Current.Request.Cookies.AllKeys)
                {
                    HttpContext.Current.Request.Cookies.Remove(cookie);
                }

                HttpContext.Current.Session.Clear();
            }

            ZumNet.Framework.Core.ServiceResult svcRt = null;

            using (CommonBiz comBiz = new CommonBiz())
            {
                svcRt = comBiz.GetUserInformation(loginId, HttpContext.Current.Request.ServerVariables["REMOTE_HOST"]
                                    , HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"], password);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                if (svcRt.ResultDataSet.Tables[0].Rows.Count > 0)
                {
                    if (svcRt.ResultDataSet.Tables[0].Rows.Count == 1)
                    {
                        DataRow dr = svcRt.ResultDataSet.Tables[0].Rows[0];
                        if (dr["PerLogon"].ToString() == "Y")
                        {
                            HttpContext.Current.Session["URID"] = dr["UserID"].ToString();
                            HttpContext.Current.Session["URACCOUNT"] = dr["MailAccount"].ToString();
                            HttpContext.Current.Session["LogonID"] = dr["LogonID"].ToString();
                            HttpContext.Current.Session["URName"] = dr["UserName"].ToString();
                            HttpContext.Current.Session["Mobile"] = dr["Mobile"].ToString();
                            HttpContext.Current.Session["TelePhone"] = dr["TelePhone"].ToString();
                            HttpContext.Current.Session["DeptName"] = dr["DeptName"].ToString();
                            HttpContext.Current.Session["DeptID"] = dr["DeptID"].ToString();
                            
                            HttpContext.Current.Session["DNID"] = dr["DN_ID"].ToString();
                            HttpContext.Current.Session["DNAlias"] = dr["DNAlias"].ToString();
                            HttpContext.Current.Session["DNName"] = dr["DomainDisplayName"].ToString();
                            HttpContext.Current.Session["MainSuffix"] = dr["Domain"].ToString();

                            HttpContext.Current.Session["ThemePath"] = dr["ThemePath"].ToString();
                            HttpContext.Current.Session["DeptAlias"] = dr["GRAlias"].ToString();
                            HttpContext.Current.Session["NickName"] = dr["NickName"].ToString();
                            HttpContext.Current.Session["BtnPath"] = "BaseButton";
                            HttpContext.Current.Session["CodeName1"] = dr["CodeName1"].ToString();      // 직위
                            //HttpContext.Current.Session["GRADE1"] = dr["CodeName1"].ToString();         // 직위
                            HttpContext.Current.Session["CodeName2"] = dr["CodeName2"].ToString();      // 직책
                            HttpContext.Current.Session["Keyword1"] = dr["Keyword1"].ToString().Trim(); //주업무

                            HttpContext.Current.Session["Belong"] = dr["Belong"].ToString().Trim();
                            HttpContext.Current.Session["BelongID"] = dr["BelongID"].ToString().Trim();
                            HttpContext.Current.Session["InDate"] = dr["InDate"].ToString().Trim();
                            HttpContext.Current.Session["FlowSvcMode"] = dr["FlowSvcMode"].ToString().Trim();
                            HttpContext.Current.Session["FlowPreAppMode"] = dr["FlowPreAppMode"].ToString().Trim();
                            
                            HttpContext.Current.Session["EmpID"] = dr["EmpID"].ToString();
                            HttpContext.Current.Session["IsSysName"] = dr["IsSysName"].ToString(); //IsPDM, IsERP, IsMSG

                            //관리자 권한 찾기
                            if (svcRt.ResultDataSet.Tables[1].Rows.Count > 0)
                            {
                                HttpContext.Current.Session["WoA"] = svcRt.ResultDataSet.Tables[1].Rows[0]["AUAlias"].ToString(); //관리툴 접근 : sysadmin, dnadmin, orgadmin
                                if (svcRt.ResultDataSet.Tables[1].Rows[0]["AUAlias"].ToString() != "orgadmin")
                                {
                                    HttpContext.Current.Session["Admin"] = "Y"; //시스템 내 관리자 역할
                                }
                                else
                                {
                                    HttpContext.Current.Session["Admin"] = "N";
                                }
                                
                            }
                            else
                            {
                                HttpContext.Current.Session["WoA"] = ""; //관리툴 접근 불가
                                HttpContext.Current.Session["Admin"] = "N";
                            }

                            //포탈 찾기
                            if (svcRt.ResultDataSet.Tables[2].Rows != null && svcRt.ResultDataSet.Tables[2].Rows.Count > 0)
                            {
                                HttpCookie Ocook = new HttpCookie("OPGroupID");
                                Ocook = HttpContext.Current.Request.Cookies["OPGroupID"];
                                string tempOP = "";

                                if (Ocook != null)
                                {
                                    tempOP = Ocook.Value;
                                }

                                if (svcRt.ResultDataSet.Tables[2].Rows.Count == 1)
                                {
                                    DataRow dr2 = svcRt.ResultDataSet.Tables[2].Rows[0];

                                    HttpContext.Current.Session["OPGroupID"] = dr2["OP_ID"].ToString();
                                    //HttpContext.Current.Session["OPGroupDsn"] = dr2["DisplayName"].ToString();
                                    //HttpContext.Current.Session["OPGroupMainLogo"] = dr2["Logo"].ToString();
                                    //HttpContext.Current.Session["OPGroupLogo"] = dr2["Logo_Small"].ToString();
                                    //HttpContext.Current.Session["OPCorpCode"] = dr2["CompanyCode"].ToString();
                                    //HttpContext.Current.Session["OPMainImage"] = dr2["MainImage"].ToString();
                                    //HttpContext.Current.Session["OPTopMenuColor"] = dr2["TopMenuColor"].ToString();
                                }
                                else
                                {
                                    //DisplaySelectPortal(ds.Tables[2]);
                                }
                            }
                            else
                            {
                                HttpContext.Current.Session["OPGroupID"] = "0";
                            }

                            //전체부서 메일 Alias 찾기
                            if (svcRt.ResultDataSet.Tables[3].Rows != null && svcRt.ResultDataSet.Tables[3].Rows.Count > 0)
                            {
                                foreach (DataRow rowOP in svcRt.ResultDataSet.Tables[3].Rows)
                                {
                                    if (strRootOrgid == string.Empty)
                                    {
                                        strRootOrgid = rowOP["GRAlias"].ToString();
                                    }
                                    else
                                    {
                                        strRootOrgid = strRootOrgid + "," + rowOP["GRAlias"].ToString();
                                    }
                                }
                            }

                            HttpContext.Current.Session["RootOrgId"] = strRootOrgid;

                            //패스워드 변경 유부
                            if (svcRt.ResultDataSet.Tables.Count > 4 && svcRt.ResultDataSet.Tables[4].Rows != null && svcRt.ResultDataSet.Tables[4].Rows.Count > 0)
                            {
                                strPwdChange = svcRt.ResultDataSet.Tables[4].Rows[0]["IsPWChange"].ToString();
                            }

                            if (strPwdChange == "Y") strReturn = "PWC";
                            else strReturn = "OK";
                        }
                        else if (dr["PerLogon"].ToString() == "D")
                        {
                            strReturn = "SYSDOWN";
                        }
                        else
                        {
                            strReturn = "NOACT";
                        }
                        dr = null;
                    }
                    else
                    {
                        strReturn = "DBLACCOUNT";
                    }
                }
            }
            else
            {
                strReturn = svcRt.ResultMessage;
            }

            //if (svcRt != null) svcRt = null;

            return strReturn;
        }
    }
}