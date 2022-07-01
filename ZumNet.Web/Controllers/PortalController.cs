using System;
using System.Collections.Generic;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Util;
using ZumNet.BSL.ServiceBiz;

namespace ZumNet.Web.Controllers
{
    public class PortalController : Controller
    {
        /// <summary>
        /// 메인 포탈
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

            //ZumNet.Framework.Core.ServiceResult svcRt = null;

            //담당 체크 및 문서함 정보
            //rt = Bc.CtrlHandler.EAInit(this, true, "");
            //if (rt != "")
            //{
            //    return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //}

            //using (ZumNet.BSL.FlowBiz.WorkList wList = new BSL.FlowBiz.WorkList())
            //{
            //    //결재함
            //    svcRt = wList.ViewProcessWorkList("av", Convert.ToInt32(Session["DNID"]), "ea", string.Empty, "", Session["URID"].ToString(), 1, 5, "", "ReceivedDate", "DESC", "", "", "", "", Convert.ToInt32(Session["URID"]));
            //    if (svcRt != null && svcRt.ResultCode == 0)
            //    {
            //        ViewBag.EA_INBOX = svcRt.ResultDataTable;
            //    }
            //    else
            //    {
            //        rt = svcRt.ResultMessage;
            //        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //    }
            //    rt = null;
            //}

            //using (BoardBiz bb = new BoardBiz())
            //{
            //    //공지사항 : RECENT_NOTICE
            //    svcRt = bb.GetPortalRecentlyMessageListOfCT(103, 1, 5, "CreateDate", "DESC", "", "", "", "", "notice", Convert.ToInt32(Session["URID"]));
            //    if (svcRt != null && svcRt.ResultCode == 0)
            //    {
            //        ViewBag.RECENT_NOTICE = svcRt.ResultDataTable;
            //    }
            //    else
            //    {
            //        rt = svcRt.ResultMessage;
            //        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //    }
            //    rt = null;

            //    //게시판 : RECENT_BOARD
            //    svcRt = bb.GetPortalRecentlyMessageListOfCT(103, 1, 5, "CreateDate", "DESC", "", "", "", "", "bbs", Convert.ToInt32(Session["URID"]));
            //    if (svcRt != null && svcRt.ResultCode == 0)
            //    {
            //        ViewBag.RECENT_BOARD = svcRt.ResultDataTable;
            //    }
            //    else
            //    {
            //        rt = svcRt.ResultMessage;
            //        return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(new Exception(rt), this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            //    }
            //    rt = null;
            //}

            //ViewBag.ChartUse = "Y";
            //using (ZumNet.DAL.ExternalDac.PQmDac pb = new DAL.ExternalDac.PQmDac())
            //{
            //    //KPI 지표현황_입고기준
            //    //ViewBag.KPI_A = pb.Get_INV_NEW_KPI("C", DateTime.Now.ToString("yyyy-MM-dd"), "0", 0);
            //    ViewBag.KPI_A = pb.Get_INV_NEW_KPI("C", "2021-01-01", "0", 0);
            //}

            //if (svcRt != null && svcRt.ResultCode == 0)
            //{
            //    ViewBag.MainMenu = svcRt.ResultDataTable;
            //    ViewBag.LindSite = svcRt.ResultDataSet;
            //    ViewBag.ShoutLnk = svcRt.ResultDataDetail["ShortLink"];
            //    ViewBag.DeptList = svcRt.ResultDataDetail["DeptList"];
            //}
            //else
            //{
            //    //에러페이지
            //}


            return View();
        }

        #region [세션생성 이후 추가 확인 작업]
        /// <summary>
        /// 출근 체크 및 비밀번호 변경
        /// </summary>
        /// <param name="Qi"></param>
        /// <param name="returnUrl"></param>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult AddCheck(string Qi, string returnUrl)
        {
            string sIP = Request.ServerVariables["REMOTE_ADDR"];
            string sUA = CommonUtils.UserAgent(Request.ServerVariables["HTTP_USER_AGENT"]);
            bool bWorkTimeCheck = false;

            try
            {
                if (Session["LogonID"].ToString() != "___byrlee") //개발자 제외
                {
                    ////허용IP : 10.212.134.1 - 10.212.134.250
                    ////         "192.168" 대역대 중 아래
                    //string[] vIP = sIP.Split('.');
                    //string[] vAllowIP = { "4", "10", "20", "30", "50", "60", "70", "80", "200" };
                    ////bool bIp = false;

                    //if (vIP[0] == "192" && vIP[1] == "168")
                    //{
                    //    if (Array.IndexOf(vAllowIP, vIP[2]) >= 0) bWorkTimeCheck = true;
                    //    else bWorkTimeCheck = false;
                    //}
                    //else if (vIP[0] == "10" && vIP[1] == "212" && vIP[2] == "134")
                    //{
                    //    bWorkTimeCheck = false;
                    //}

                    bWorkTimeCheck = CommonUtils.WorkIPBand(sIP); //22-06-30

                    if (bWorkTimeCheck)
                    {
                        if (Session["LogonID"].ToString() != "swjeong" && Session["LogonID"].ToString() != "kimsj") //아래 조건에 속하나 포함 할 대상자
                        {
                            //제외부서 : 부서명 영문 I, C, V, G가 들어가는 경우, 재무광동, 재무베트남, 재무인니, 업무지원, 금형관리, 임원실(산업)
                            if (Session["DeptName"].ToString().IndexOf('I') != -1 || Session["DeptName"].ToString().IndexOf('C') != -1 || Session["DeptName"].ToString().IndexOf('V') != -1 || Session["DeptName"].ToString().IndexOf('G') != -1 || Session["DeptName"].ToString().IndexOf("하노이") != -1
                                || Session["DeptName"].ToString() == "재무광동" || Session["DeptName"].ToString() == "재무베트남" || Session["DeptName"].ToString() == "재무인니" || Session["DeptName"].ToString() == "업무지원" || Session["DeptName"].ToString() == "금형관리" || Session["DeptName"].ToString() == "임원실(산업)" || Session["DeptName"].ToString() == "광동기구"
                                || Session["DeptName"].ToString() == "재무팀광동" || Session["DeptName"].ToString() == "재무팀베트남" || Session["DeptName"].ToString() == "재무팀인니")
                            {
                                bWorkTimeCheck = false;
                            }

                            //제외사용자
                            string[] vExceptionUser = { "이종배", "배경태", "오우동", "홍순경", "이태윤", "김경덕", "민팀윤", "허영세", "이효정", "양병일", "방철군", "김우진", "엄이식", "이정근", "지재용", "윤도현", "박정규", "최우원", "박형열", "안내데스크", "변가윤", "박재천" };
                            foreach (string s in vExceptionUser)
                            {
                                if (s == Session["URName"].ToString())
                                {
                                    bWorkTimeCheck = false;
                                }
                            }
                        }
                    }
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;

                Dictionary<string, string> dicStatus = new Dictionary<string, string>();
                dicStatus.Add("PwdChange", (Qi == "PWC" ? "Y" : "N"));
                dicStatus.Add("WorkStatus", "_");
                dicStatus.Add("PlanInTime", "");
                dicStatus.Add("PlanOutTime", "");
                dicStatus.Add("InTime", "");
                dicStatus.Add("OutTime", "");

                //0시~6시 사이는 기준 근무일자를 하루전으로
                string sWorkDate = (DateTime.Now.Hour < 6) ? DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") : DateTime.Now.ToString("yyyy-MM-dd");

                //ZumNet.Framework.Log.Logging.WriteDebug(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "AddCheck", bWorkTimeCheck.ToString(), Environment.NewLine));

                if (bWorkTimeCheck)
                {
                    //근무상태체크 제외 세션으로 설정
                    Session["UseWorkTime"] = "Y"; //허용

                    //근무상태확인
                    //using (WorkTimeBiz wtBiz = new WorkTimeBiz())
                    //{
                    //    svcRt = wtBiz.CheckWorkTimeStatus("", Convert.ToInt32(Session["URID"]), sWorkDate, 0, sIP, sUA);
                    //}
                    WorkTimeBiz wtBiz = new WorkTimeBiz();
                    svcRt = wtBiz.CheckWorkTimeStatus("", Convert.ToInt32(Session["URID"]), sWorkDate, 0, sIP, sUA);

                    if (svcRt.ResultDataDetail.Count > 0)
                    {
                        foreach (string key in svcRt.ResultDataDetail.Keys)
                        {
                            dicStatus[key] = svcRt.ResultDataDetail[key].ToString();
                        }
                    }

                    //2021-11-24 출근하기 로그인으로 대체
                    if (dicStatus["WorkStatus"] == "A")
                    {
                        svcRt = wtBiz.SetWorkTimeStatus(Convert.ToInt32(Session["URID"]), DateTime.Now.ToString("yyyy-MM-dd")
                                                    , dicStatus["WorkStatus"].ToString(), Request.ServerVariables["REMOTE_ADDR"], sUA);
                    }
                    wtBiz.Dispose();

                    if (dicStatus["PwdChange"] == "Y" || dicStatus["WorkStatus"] == "__A" || dicStatus["WorkStatus"] == "Z")
                    {
                    }
                    else
                    {
                        //출퇴근 체크 X. 비밀번호 변경 X
                        return RedirectToLocal(returnUrl);
                    }
                }
                else
                {
                    Session["UseWorkTime"] = "N";

                    if (dicStatus["PwdChange"] == "N") return RedirectToLocal(returnUrl);
                }

                ViewBag.ReturnUrl = returnUrl;
                return View(dicStatus);
            }
            catch(Exception ex)
            {
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(ex, this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
        }
        #endregion

        #region [기타 + 유틸함수]
        /// <summary>
        /// SSO
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult SSOerp()
        {
            return View();
        }

        /// <summary>
        /// 언어 설정
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Locale()
        {
            string strView = "";
            try
            {
                if (Request.IsAjaxRequest())
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if ((jPost == null || jPost.Count == 0) && jPost["locale"].ToString() == "")
                    {
                        return "필수값 누락!";
                    }

                    AuthManager.SetLocaleCookie(jPost["locale"].ToString());

                    strView = "OK";
                }
            }
            catch(Exception ex)
            {
                strView = ex.Message;
            }
            return strView;
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
        #endregion
    }
}