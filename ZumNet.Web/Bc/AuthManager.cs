using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;

using ZumNet.Framework.Util;
using ZumNet.BSL.ServiceBiz;
using System.Configuration;
using System.Globalization;
using System.Threading;
using ZumNet.Framework.Model;

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
                            // MemberModel 객체 생성하여 세션에 저장
                            //MemberModel model = new MemberModel(svcRt.ResultDataTable);
                            //HttpContext.Current.Session.Add("UserInfo", model);

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

        /// <summary>
        /// 근무상태
        /// </summary>
        /// <param name="logonUser"></param>
        /// <param name="logonDept"></param>
        /// <param name="logonIP"></param>
        /// <returns></returns>
        public Dictionary<string, string> CheckWorkTimeStatus(string logonUser, string logonDept, string logonIP)
        {
            //string sIP = HttpContext.Current.Request.ServerVariables["REMOTE_HOST"];
            string sUA = CommonUtils.UserAgent(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //근무상태체크 제외 세션으로 설정
            HttpContext.Current.Session["UseWorkTime"] = "Y"; //허용

            if (HttpContext.Current.Session["LogonID"].ToString() != "byrlee") //개발자 제외
            {
                //허용IP : 10.212.134.1 - 10.212.134.250
                //         "192.168" 대역대 중 아래
                string[] vIP = logonIP.Split('.');
                string[] vAllowIP = { "4", "10", "20", "30", "50", "60", "70", "80", "200" };
                bool bIp = false;

                if (vIP[0] == "192" && vIP[1] == "168")
                {
                    //foreach (string s in vExceptionIP)
                    //{
                    //    if (s == vIP[2])
                    //    {
                    //        bIp = true; break;
                    //    }
                    //}

                    if (Array.IndexOf(vAllowIP, vIP[2]) >= 0) bIp = true;

                }
                else if (vIP[0] == "10" && vIP[1] == "212" && vIP[2] == "134")
                {
                    //if (Convert.ToInt16(vIP[3]) >= 1 && Convert.ToInt16(vIP[3]) <= 250) bIp = true;
                }
                else if (vIP[0] == "::1")
                {
                    bIp = true; //테스트 용
                }

                if (!bIp)
                {
                    return SetNonWorkTime();
                }

                if (HttpContext.Current.Session["LogonID"].ToString() != "swjeong" && HttpContext.Current.Session["LogonID"].ToString() != "kimsj") //아래 조건에 속하나 포함 할 대상자
                {
                    //제외부서 : 부서명 영문 I, C, V, G가 들어가는 경우, 재무광동, 재무베트남, 재무인니, 업무지원, 금형관리, 임원실(산업)
                    if (logonDept.IndexOf('I') != -1 || logonDept.IndexOf('C') != -1 || logonDept.IndexOf('V') != -1 || logonDept.IndexOf('G') != -1 || logonDept.IndexOf("하노이") != -1
                        || logonDept == "재무광동" || logonDept == "재무베트남" || logonDept == "재무인니" || logonDept == "업무지원" || logonDept == "금형관리" || logonDept == "임원실(산업)" || logonDept == "광동기구"
                        || logonDept == "재무팀광동" || logonDept == "재무팀베트남" || logonDept == "재무팀인니")
                    {
                        return SetNonWorkTime();
                    }

                    //제외사용자
                    string[] vExceptionUser = { "이종배", "배경태", "오우동", "홍순경", "이태윤", "김경덕", "민팀윤", "허영세", "이효정", "양병일", "방철군", "김우진", "엄이식", "이정근", "지재용", "윤도현", "박정규", "최우원", "박형열", "안내데스크", "변가윤", "박재천" };
                    foreach (string s in vExceptionUser)
                    {
                        if (s == logonUser)
                        {
                            return SetNonWorkTime();
                        }
                    }
                }
            }

            Dictionary<string, string> dicReturn = new Dictionary<string, string>();

            //0시~6시 사이는 기준 근무일자를 하루전으로
            string sWorkDate = (DateTime.Now.Hour < 6) ? DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") : DateTime.Now.ToString("yyyy-MM-dd");

            //근무상태확인 20-03-04
            using (WorkTimeBiz wtBiz = new WorkTimeBiz())
            {
                svcRt = wtBiz.CheckWorkTimeStatus("", Convert.ToInt32(HttpContext.Current.Session["URID"]), sWorkDate, 0, logonIP, sUA);
            }

            if (svcRt.ResultDataDetail.Count > 0)
            {
                foreach(string key in svcRt.ResultDataDetail.Keys)
                {
                    dicReturn.Add(key, svcRt.ResultDataDetail[key].ToString());
                }
            }
            else
            {
                return SetNonWorkTime();
            }

            return dicReturn;
        }

        private Dictionary<string, string> SetNonWorkTime()
        {
            HttpContext.Current.Session["UseWorkTime"] = "N";

            Dictionary<string, string> dicReturn = new Dictionary<string, string>();

            dicReturn.Add("WorkStatus", "_");
            dicReturn.Add("PlanInTime", "");
            dicReturn.Add("PlanOutTime", "");
            dicReturn.Add("InTime", "");
            dicReturn.Add("OutTime", "");

            return dicReturn;
        }

        /// <summary>
        /// CurrentCulture 및 쿠키 설정
        /// </summary>
        public static void SetLocaleCookie()
        {
            string culture = "";

            HttpCookie ck = HttpContext.Current.Request.Cookies["locale"];

            if (ck != null)
            {
                culture = ck.Value; // HttpContext.Current.Request.Cookies["locale"].Value;
            }
            else
            {
                if (HttpContext.Current.Request.UserLanguages != null)
                {
                    culture = HttpContext.Current.Request.UserLanguages[0];
                }
                else
                {
                    culture = ConfigurationManager.AppSettings["DefaultLocale"];  //"ko-KR";    
                }

                ck = new HttpCookie("locale");
                ck.Name = "locale";
                ck.Value = culture;
            }

            ck.Expires = DateTime.Now.AddDays(30); //30일

            HttpContext.Current.Response.Cookies.Add(ck);

            //if (cultureSet)
            //{
            //    CultureInfo ci = new CultureInfo(culture);

            //    Thread.CurrentThread.CurrentCulture = ci; // CultureInfo.GetCultureInfo(culture);
            //    Thread.CurrentThread.CurrentUICulture = ci; // CultureInfo.GetCultureInfo(culture);
            //}
            
        }

        /// <summary>
        /// CurrentCulture 및 쿠키 설정
        /// </summary>
        /// <param name="culture"></param>
        public static void SetLocaleCookie(string culture)
        {
            if (culture != "")
            {
                HttpCookie ck = HttpContext.Current.Request.Cookies["locale"];
                if (ck == null)
                {
                    ck = new HttpCookie("locale");
                    ck.Name = "locale";
                }

                ck.Value = culture;
                ck.Expires = DateTime.Now.AddDays(30); //30일

                HttpContext.Current.Response.Cookies.Add(ck);

                //if (cultureSet)
                //{
                //    CultureInfo ci = new CultureInfo(culture);

                //    Thread.CurrentThread.CurrentCulture = ci; // CultureInfo.GetCultureInfo(culture);
                //    Thread.CurrentThread.CurrentUICulture = ci; // CultureInfo.GetCultureInfo(culture);
                //}
            }
        }
    }
}