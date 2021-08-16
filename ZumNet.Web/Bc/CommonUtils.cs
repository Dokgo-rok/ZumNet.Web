using System;
using System.Collections;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    /// <summary>
    /// 공통 유틸 클래스
    /// </summary>
    public class CommonUtils
    {
        /// <summary>
        /// 
        /// </summary>
        public CommonUtils() { }

        #region [Post Data 반환]
        /// <summary>
        /// string 반환
        /// </summary>
        /// <returns></returns>
        public static string PostDataToString()
        {
            Byte[] postData = HttpContext.Current.Request.BinaryRead(HttpContext.Current.Request.TotalBytes);
            UTF8Encoding utf8 = new UTF8Encoding();
            return utf8.GetString(postData, 0, postData.Length);
        }

        /// <summary>
        /// hashtable 반환
        /// </summary>
        /// <returns></returns>
        public static Hashtable PostDataToHash()
        {
            Hashtable ht = null;
            Byte[] postData = HttpContext.Current.Request.BinaryRead(HttpContext.Current.Request.TotalBytes);
            if (postData.Length > 0)
            {
                UTF8Encoding utf8 = new UTF8Encoding();
                string[] vPost = utf8.GetString(postData, 0, postData.Length).Split('&');

                ht = new Hashtable();
                foreach (string s in vPost)
                {
                    string[] temp = s.Split('=');
                    ht.Add(temp[0], temp[1]);
                }
            }
            return ht;
        }

        /// <summary>
        /// json 반환
        /// </summary>
        /// <returns></returns>
        public static JObject PostDataToJson()
        {
            JObject jObject = null;
            Byte[] postData = HttpContext.Current.Request.BinaryRead(HttpContext.Current.Request.TotalBytes);
            if (postData.Length > 0)
            {
                UTF8Encoding utf8 = new UTF8Encoding();
                jObject = JObject.Parse(utf8.GetString(postData, 0, postData.Length));
            }
            return jObject;
        }
        #endregion

        #region [날짜 시간관련]
        /// <summary>
        /// 년도 구성
        /// </summary>
        /// <param name="st"></param>
        /// <returns></returns>
        public static string OptionYear(int curYear, int st)
        {
            string strReturn = "";
            for (int i = curYear; i >= st; i--)
            {
                if (i == curYear) strReturn += String.Format("<option value=\"{0}\" selected=\"selected\">{0}년</option>", i.ToString());
                else strReturn += String.Format("<option value=\"{0}\">{0}년</option>", i.ToString());
            }
            return strReturn;
        }

        /// <summary>
        /// 월 구성
        /// </summary>
        /// <param name="vlu"></param>
        /// <returns></returns>
        public static string OptionMonth(int vlu)
        {
            string strReturn = "";
            for (int i = 1; i <= 12; i++)
            {
                if (i == vlu) strReturn += String.Format("<option value=\"{0}\" selected=\"selected\">{0}월</option>", i.ToString());
                else strReturn += String.Format("<option value=\"{0}\">{0}월</option>", i.ToString());
            }
            return strReturn;
        }

        /// <summary>
        /// 주차 구성
        /// </summary>
        /// <param name="vlu"></param>
        /// <returns></returns>
        public static string OptionWeek(int start, int end, int current)
        {
            string strReturn = "";
            for (int i = end; i >= start; i--)
            {
                if (current > 0 && i == current) strReturn += String.Format("<option value=\"{0}\" selected=\"selected\">{0} 주차</option>", i.ToString());
                else strReturn += String.Format("<option value=\"{0}\">{0} 주차</option>", i.ToString());
            }
            return strReturn;
        }

        /// <summary>
        /// 시간 구성
        /// </summary>
        /// <param name="hh"></param>
        /// <param name="mm"></param>
        /// <returns></returns>
        public static string OptionTime(string hh, string mm)
        {
            return OptionTime(Convert.ToInt32(hh), Convert.ToInt32(mm));
        }

        public static string OptionTime(int hh, int mm)
        {
            StringBuilder sb = new StringBuilder();
            string sH = "", sM = "";


            for (int i = 0; i < 24; i++)
            {
                sH = (i < 10) ? "0" + i.ToString() : i.ToString();

                if (i == hh)
                {
                    if (mm >= 30)
                    {
                        sb.AppendFormat("<option value=\"{0}:00\">{0}:00</option>", sH);
                        sb.AppendFormat("<option value=\"{0}:30\" selected=\"selected\">{0}:30</option>", sH);
                    }
                    else
                    {
                        sb.AppendFormat("<option value=\"{0}:00\" selected=\"selected\">{0}:00</option>", sH);
                        sb.AppendFormat("<option value=\"{0}:30\">{0}:30</option>", sH);
                    }
                }
                else
                {
                    sb.AppendFormat("<option value=\"{0}:00\">{0}:00</option>", sH);
                    sb.AppendFormat("<option value=\"{0}:30\">{0}:30</option>", sH);
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// 특정 시간대 드랍다운
        /// </summary>
        /// <param name="hh"></param>
        /// <param name="mm"></param>
        /// <param name="from"></param>
        /// <param name="to"></param>
        /// <returns></returns>
        public static string OptionTime(int hh, int mm, int from, int to)
        {
            StringBuilder sb = new StringBuilder();
            string sH = "", sM = "";
            int iTo = (from > to) ? 24 : to;

            for (int i = from; i <= iTo; i++)
            {
                sH = (i < 10) ? "0" + i.ToString() : i.ToString();

                if (i == hh)
                {
                    if (mm >= 30)
                    {
                        if (i > 0) sb.AppendFormat("<option value=\"{0}:00\">{0}:00</option>", sH);
                        if (i < iTo) sb.AppendFormat("<option value=\"{0}:30\" selected=\"selected\">{0}:30</option>", sH);
                    }
                    else
                    {
                        if (i > 0) sb.AppendFormat("<option value=\"{0}:00\" selected=\"selected\">{0}:00</option>", sH);
                        if (i < iTo) sb.AppendFormat("<option value=\"{0}:30\">{0}:30</option>", sH);
                    }
                }
                else
                {
                    if (i > 0) sb.AppendFormat("<option value=\"{0}:00\">{0}:00</option>", sH);
                    if (i < iTo) sb.AppendFormat("<option value=\"{0}:30\">{0}:30</option>", sH);
                }
            }
            if (from > to) sb.Append(OptionTime(hh, mm, 0, to));
            return sb.ToString();
        }

        /// <summary>
        /// 특정 시간대 드랍다운
        /// </summary>
        /// <param name="hh"></param>
        /// <param name="mm"></param>
        /// <param name="from"></param>
        /// <param name="to"></param>
        /// <returns></returns>
        public static string DropDownTime(int from, int to)
        {
            StringBuilder sb = new StringBuilder();
            string sH = "", sM = "";
            int iTo = (from > to) ? 24 : to;

            for (int i = from; i <= iTo; i++)
            {
                sH = (i < 10) ? "0" + i.ToString() : i.ToString();

                sb.AppendFormat("<li><a href=\"javascript:\" data-value=\"{0}:00\">{0}:00</a></li>", sH);
                if (i < iTo) sb.AppendFormat("<li><a href=\"javascript:\" data-value=\"{0}:30\">{0}:30</a></li>", sH);
            }
            if (from > to) sb.Append(DropDownTime(0, to));
            return sb.ToString();
        }

        /// <summary>
        /// 날짜 시분초 반환
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public static string StrHHmmss(string date)
        {
            try
            {
                return Convert.ToDateTime(date).ToString("HH:mm:ss");
            }
            catch
            {
                return "0";
            }
        }

        /// <summary>
        /// 날짜 시분 반환
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public static string StrHHmm(string date)
        {
            try
            {
                return Convert.ToDateTime(date).ToString("HH:mm");
            }
            catch
            {
                return "0";
            }
        }

        /// <summary>
        /// TimeSpan 시분 변환
        /// </summary>
        /// <param name="ts"></param>
        /// <returns></returns>
        public static string StrTimeSpan(string t)
        {
            try
            {
                string sPrefix = "";
                if (Convert.ToInt64(t) < 0)
                {
                    sPrefix = "-";
                    t = t.Replace("-", "");
                }

                TimeSpan ts = new TimeSpan(Convert.ToInt64(t));
                if (ts.Days > 0) return sPrefix + ts.Days.ToString() + "d " + (ts.Hours > 0 ? ts.Hours.ToString() + "h " : "") + (ts.Minutes > 0 ? ts.Minutes.ToString() + "m" : "");
                else if (ts.Hours > 0) return sPrefix + ts.Hours.ToString() + "h " + (ts.Minutes > 0 ? ts.Minutes.ToString() + "m" : "");
                else if (ts.Minutes > 0) return sPrefix + ts.Minutes.ToString() + "m"; ;
                return "0";
            }
            catch
            {
                return "";
            }
        }

        /// <summary>
        /// 시변환
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public static string StrHour(string t)
        {
            try
            {
                long h = Convert.ToInt64(t);
                return (h != 0) ? (new TimeSpan(h)).TotalHours.ToString("#.0") : "";
            }
            catch
            {
                return "";
            }
        }

        /// <summary>
        /// 월 자리수
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        public static string StrMonth(int m)
        {
            return (m < 10) ? "0" + m.ToString() : m.ToString();
        }

        /// <summary>
        /// 날짜 구성
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public static string CheckDateTime(string date)
        {
            return CheckDateTime(date, "yy-MM-dd HH:mm", "");
        }

        /// <summary>
        /// 날짜 구성
        /// </summary>
        /// <param name="date">대상</param>
        /// <param name="format">날짜형식</param>
        /// <param name="exDate">대체값</param>
        /// <returns></returns>
        public static string CheckDateTime(string date, string format, string exDate)
        {
            string strReturn = "";

            if (date != null)
            {
                if (date != "")
                {
                    try
                    {
                        DateTime d = Convert.ToDateTime(date);
                        if (d != null) if (DateTime.Compare(d, Convert.ToDateTime("1900-01-01")) > 0 && DateTime.Compare(d, Convert.ToDateTime("2999-01-01")) < 0) strReturn = d.ToString(format);
                    }
                    catch (Exception ex)
                    {
                        strReturn = exDate;
                    }
                }
            }
            return strReturn;
        }

        /// <summary>
        /// 날짜 계산
        /// </summary>
        /// <param name="sD"></param>
        /// <param name="eD"></param>
        /// <param name="d"></param>
        /// <returns></returns>
        public static string DateDiff(string sD, string eD, int d)
        {
            string strReturn = "";
            TimeSpan ts = DateTime.Parse(eD) - DateTime.Parse(sD);
            if (ts.Days > 0) strReturn = ts.Days.ToString() + "d " + ts.Hours.ToString() + "h " + ts.Minutes.ToString() + "m";
            else if (ts.Hours > 0) strReturn = ts.Hours.ToString() + "h " + ts.Minutes.ToString() + "m";
            else strReturn = ts.Minutes.ToString() + "m";

            if (ts.Days > d) strReturn = "<strong style=\"color:red;font-family:맑은 고딕\">" + strReturn + "</strong>";

            return strReturn;
        }

        /// <summary>
        /// 날짜 차이 반환
        /// </summary>
        /// <param name="sD"></param>
        /// <param name="eD"></param>
        /// <returns></returns>
        public static double DateDiff(string sD, string eD)
        {
            return DateDiff(sD, eD, "d");
        }

        /// <summary>
        /// 날짜 차이 반환
        /// </summary>
        /// <param name="sD"></param>
        /// <param name="eD"></param>
        /// <param name="f"></param>
        /// <returns></returns>
        public static double DateDiff(string sD, string eD, string f)
        {
            TimeSpan ts = DateTime.Parse(eD) - DateTime.Parse(sD);
            if (f == "h") return ts.TotalHours;
            else if (f == "m") return ts.TotalMinutes;
            else return ts.TotalDays;
        }

        /// <summary>
        /// 분 -> 시간
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        public static string CvtMinToHour(string m)
        {
            if (m == "") m = "0";
            return (Convert.ToDouble(m) / 60).ToString();
        }

        /// <summary>
        /// 현재 주차 또는 특정 년도 마지막 주차 반환
        /// </summary>
        /// <returns></returns>
        public static int GetWeekOfYear(int year)
        {
            return (year > 0) ? GetWeekOfYear(year, 12, 31) : GetWeekOfYear(System.DateTime.Now.Year, System.DateTime.Now.Month, System.DateTime.Now.Day);
        }

        public static int GetWeekOfYear(int year, int month, int day)
        {
            DateTime sourceDate = new DateTime(year, month, day);
            CultureInfo cultureInfo = CultureInfo.CurrentCulture;

            CalendarWeekRule calendarWeekRule = cultureInfo.DateTimeFormat.CalendarWeekRule;
            DayOfWeek firstDayOfWeek = cultureInfo.DateTimeFormat.FirstDayOfWeek;
            firstDayOfWeek = DayOfWeek.Monday;

            return cultureInfo.Calendar.GetWeekOfYear(sourceDate, calendarWeekRule, firstDayOfWeek);
        }

        /// <summary>
        /// 주어진 주차에 해당하는 일자 반환
        /// </summary>
        public static DateTime GetDateOfWeek(int year, int week)
        {
            DateTime firstDateOfYear = new DateTime(year, 1, 1);
            DateTime firstDateOfFirstWeek = firstDateOfYear.AddDays((int)DayOfWeek.Monday - (int)(firstDateOfYear.DayOfWeek));
            return firstDateOfFirstWeek.AddDays(7 * (week - 1));
        }
        #endregion

        #region [숫자 문자열 관련]
        /// <summary>
        /// 통화 반환
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string CvtCurrency(string s)
        {
            return CvtCurrency(s, 2);
        }

        /// <summary>
        /// 통화 반환
        /// </summary>
        /// <param name="s"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public static string CvtCurrency(string s, int n)
        {
            try
            {
                if (n == 0) return Convert.ToDecimal(s).ToString("#,0");
                else if (n == 1) return Convert.ToDecimal(s).ToString("#,0.#");
                else if (n == 2) return Convert.ToDecimal(s).ToString("#,0.##");
                else if (n == 3) return Convert.ToDecimal(s).ToString("#,0.###");
                else if (n == 4) return Convert.ToDecimal(s).ToString("#,0.####");
                else if (n == 5) return Convert.ToDecimal(s).ToString("#,0.#####");
                else return Convert.ToDecimal(s).ToString("#,0.##");
                //return Convert.ToDecimal(s).ToString("#,###.##");                
            }
            catch
            {
                return "0";
            }
        }

        /// <summary>
        /// 표준 숫자 서식 문자열
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string CvtNumeric(string s)
        {
            return CvtNumeric(s, 2);
        }

        /// <summary>
        /// 표준 숫자 서식 문자열
        /// </summary>
        /// <param name="s"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public static string CvtNumeric(string s, int n)
        {
            try
            {
                return Convert.ToDecimal(s).ToString("n" + n);
            }
            catch
            {
                return Convert.ToDecimal("0").ToString("n" + n);
            }
        }

        /// <summary>
        /// 표준 숫자 서식 문자열
        /// </summary>
        /// <param name="s"></param>
        /// <param name="n"></param>
        /// <param name="rpl"></param>
        /// <returns></returns>
        public static string CvtNumeric(string s, int n, string rpl)
        {
            try
            {
                return (Convert.ToDecimal(s) == 0) ? rpl : Convert.ToDecimal(s).ToString("n" + n);
            }
            catch
            {
                return rpl;
            }
        }

        /// <summary>
        /// 백분율 문자열
        /// </summary>
        /// <param name="s"></param>
        /// <param name="n"></param>
        /// <param name="rpl"></param>
        /// <returns></returns>
        public static string StrPercent(string s, int n, string rpl)
        {
            try
            {
                return (Convert.ToDecimal(s) == 0) ? rpl : Convert.ToDecimal(s).ToString("n" + n) + "%";
            }
            catch
            {
                return rpl;
            }
        }

        /// <summary>
        /// 백분율 문자열
        /// </summary>
        /// <param name="s1"></param>
        /// <param name="s2"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public static string CvtPercent(string s1, string s2, int n)
        {
            decimal d1 = 0;
            decimal d2 = 0;
            decimal dRt = 0;

            try
            {
                d1 = Convert.ToDecimal(s1);
                d2 = Convert.ToDecimal(s2);

                if (d2 > 0) dRt = Math.Round(d1 / d2 * 100, n);
                else dRt = 0;
            }
            catch
            {
                dRt = 0;
            }
            return dRt.ToString("n" + n);
        }

        /// <summary>
        /// 백분율 문자열
        /// </summary>
        /// <param name="s1"></param>
        /// <param name="s2"></param>
        /// <param name="s3"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public static string CvtPercent(string s1, string s2, string s3, int n)
        {
            decimal d = 0;

            try
            {
                d = Convert.ToDecimal(s1) - Convert.ToDecimal(s2);
            }
            catch
            {
                d = 0;
            }
            return CvtPercent(d.ToString(), s3, n);
        }

        /// <summary>
        /// 차이 문자열
        /// </summary>
        /// <param name="s1"></param>
        /// <param name="s2"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public static string StrMinus(string s1, string s2, int n)
        {
            decimal d = 0;

            try
            {
                d = Convert.ToDecimal(s1) - Convert.ToDecimal(s2);
            }
            catch
            {
                d = 0;
            }
            return CvtNumeric(d.ToString(), n);
        }

        /// <summary>
        /// JSON Decode
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string JsonDecode(string s)
        {
            return s.Replace("\"", "&quot;").Replace("\'", "&apos;").Replace("\r", "\\r").Replace("\n", "\\n");
        }

        /// <summary>
        /// 빈 문자열 반환
        /// </summary>
        /// <param name="s"></param>
        /// <param name="html"></param>
        /// <returns></returns>
        public static string IsEmpty(string s, bool html)
        {
            if (s == null || s == "") return (html) ? "&nbsp;" : "";
            else return s;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string ReplaceReply(string s)
        {
            //return s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("&quot;", "\\\"").Replace("&quot", "\\\"").Replace(" ", "&nbsp;").Replace(Environment.NewLine, "<br />");
            return s.Replace(" ", "&nbsp;").Replace(Environment.NewLine, "<br />");
        }
        #endregion

        #region [리스트뷰 날짜 표현]

        /// <summary>
        /// 리스트뷰 날짜 표현
        /// </summary>
        /// <param name="d"></param>
        /// <returns></returns>
        public static string LvDate(string d)
        {
            return LvDate(d, false);
        }

        /// <summary>
        /// 리스트뷰 날짜 표현
        /// </summary>
        /// <param name="d"></param>
        /// <param name="showTime"></param>
        /// <returns></returns>
        public static string LvDate(string d, bool showTime)
        {
            string strRt = "";

            if (!String.IsNullOrWhiteSpace(d))
            {
                DateTime t = Convert.ToDateTime(d);

                string sCurrentLocale = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;
                string fShort;
                string fLong;

                if (sCurrentLocale.Substring(0, 2).ToLower() == "ko")
                {
                    fLong = "yy-MM-dd"; fShort = "MM-dd";
                }
                else if (sCurrentLocale.Substring(0, 2).ToLower() == "zh" || sCurrentLocale.Substring(0, 2).ToLower() == "ja")
                {
                    fLong = "yy/MM/dd"; fShort = "MM/dd";
                }
                else
                {
                    fLong = "MM/dd/yy"; fShort = "MM/dd";
                }

                if (showTime)
                {
                    fLong += " HH:mm";
                    fShort += " HH:mm";
                }

                if (t.ToShortDateString() == DateTime.Now.ToShortDateString()) strRt = t.ToString("HH:mm");
                else if (t.Year == DateTime.Now.Year) strRt = t.ToString(fShort);
                else strRt = t.ToString(fLong);
            }

            return strRt;
        }
        #endregion

        #region [리스트뷰 게시물 갯수 포함 쿠키 관련]
        /// <summary>
        /// 쿠키 설정
        /// </summary>
        /// <param name="name"></param>
        /// <param name="value"></param>
        public static void SetCookie(string name, string value)
        {
            if (value != "")
            {
                HttpCookie ck = HttpContext.Current.Request.Cookies[name];
                if (ck == null)
                {
                    ck = new HttpCookie(name);
                    ck.Name = name;
                }

                ck.Value = value;
                ck.Expires = DateTime.Now.AddMonths(1); //기본 한달

                HttpContext.Current.Response.Cookies.Add(ck);
            }
        }

        /// <summary>
        /// 쿠키값 가져오기
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string GetCookie(string name)
        {
            HttpCookie ck = HttpContext.Current.Request.Cookies[name];

            return ck != null ? ZumNet.Framework.Util.StringHelper.SafeString(ck.Value, "") : "";
        }

        /// <summary>
        /// 쿠키 리스트뷰 게시물 갯수 설정
        /// </summary>
        /// <param name="category"></param>
        /// <param name="value"></param>
        public static void SetLvCookie(string category, string value)
        {
            if (value != "")
            {
                string sName = "";
                if (category.ToLower() == "ea") sName = "eaLvCount";
                else if (category.ToLower() == "doc") sName = "docLvCount";
                else sName = "bbsLvCount";

                HttpCookie ck = HttpContext.Current.Request.Cookies[sName];
                if (ck == null)
                {
                    ck = new HttpCookie(sName);
                    ck.Name = sName;
                }

                ck.Value = value;
                ck.Expires = DateTime.Now.AddYears(1);

                HttpContext.Current.Response.Cookies.Add(ck);
            }
        }

        /// <summary>
        /// 쿠키 리스트뷰 게시물 갯수 가져오기
        /// </summary>
        /// <param name="category"></param>
        /// <returns></returns>
        public static int GetLvCookie(string category)
        {
            string sName = "";
            if (category.ToLower() == "ea") sName = "eaLvCount";
            else if (category.ToLower() == "doc") sName = "docLvCount";
            else sName = "bbsLvCount";

            HttpCookie ck = HttpContext.Current.Request.Cookies[sName];

            return ck != null ? ZumNet.Framework.Util.StringHelper.SafeInt(ck.Value, 20) : 20;
        }
        #endregion

        #region [브라우저 관련]
        /// <summary>
        /// 전역 구분자
        /// </summary>
        /// <returns></returns>
        public static string BOUNDARY()
        {
            return "__" + SecurityHelper.ToBase64("boundary_" + HttpContext.Current.Session.SessionID, "utf-8") + "__";
        }

        /// <summary>
        /// 브라우저 및 모바일 판단
        /// </summary>
        /// <returns></returns>
        public static string UserAgent()
        {
            return UserAgent(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);
        }

        /// <summary>
        /// 브라우저 및 모바일 판단
        /// </summary>
        /// <param name="userAgent"></param>
        /// <returns></returns>
        public static string UserAgent(string userAgent)
        {
            string pattern = "(iPhone|iPod|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson|LG|SAMSUNG|Samsung)";

            string sMobile = "";
            string sBrowser = "";

            if (IsMobile(userAgent))
            {
                Match m = Regex.Match(userAgent, pattern);
                sMobile = m.Value;
                if (sMobile == "") sMobile = "Android";
            }
            else
            {
                sMobile = "PC";
            }

            if (userAgent.IndexOf("MSIE") > 0) sBrowser = "MSIE";
            else if (userAgent.IndexOf("Edge") > 0) sBrowser = "Edge";
            else if (userAgent.IndexOf("OPR") > 0) sBrowser = "Opera ";
            else if (userAgent.IndexOf("Firefox") > 0) sBrowser = "Firefox";
            else if (userAgent.IndexOf("Chrome") > 0) sBrowser = "Chrome";
            else sBrowser = "MSIE";

            return sMobile + "/" + sBrowser;
        }

        /// <summary>
        /// 모바일여부 판단
        /// </summary>
        /// <returns></returns>
        public static bool IsMobile()
        {
            return IsMobile(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);
        }

        /// <summary>
        /// 모바일여부 판단
        /// </summary>
        /// <param name="userAgent"></param>
        /// <returns></returns>
        public static bool IsMobile(string userAgent)
        {
            //string u = HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"];

            Regex b = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
            Regex v = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);

            return (b.IsMatch(userAgent) || v.IsMatch(userAgent.Substring(0, 4)));
        }
        #endregion
    }

    #region [RazorViewToString 클래스]
    /// <summary>
    /// 뷰 페이지 문자열
    /// </summary>
    public static class RazorViewToString
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="viewName"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        public static string RenderRazorViewToString(this Controller ctrl, string viewName, object model)
        {
            ctrl.ViewData.Model = model;
            using (var sw = new StringWriter())
            {
                var viewResult = ViewEngines.Engines.FindPartialView(ctrl.ControllerContext, viewName);
                var viewContext = new ViewContext(ctrl.ControllerContext, viewResult.View, ctrl.ViewData, ctrl.TempData, sw);
                viewResult.View.Render(viewContext, sw);
                viewResult.ViewEngine.ReleaseView(ctrl.ControllerContext, viewResult.View);
                return sw.GetStringBuilder().ToString();
            }
        }
    }
    #endregion

    #region [CtrlHandler 클래스]
    /// <summary>
    /// 컨트롤러 공통 작업
    /// </summary>
    public static class CtrlHandler
    {
        /// <summary>
        /// 전체 새로고침 되는 페이지 초기 데이터 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="useCache"></param>
        /// <returns></returns>
        public static string PageInit(this Controller ctrl, bool useCache)
        {
            ZumNet.Framework.Core.ServiceResult svcRt = null;
            string strReturn = "";

            if (!useCache)
            {
                string strLocale = System.Threading.Thread.CurrentThread.CurrentUICulture.Name;

                //캐쉬 미사용
                using (ZumNet.BSL.ServiceBiz.CommonBiz com = new ZumNet.BSL.ServiceBiz.CommonBiz())
                {
                    //svcRt = com.GetMenuInformation(1, 0, 101374, "N", "0", "KO");
                    svcRt = com.GetMenuTop(1, Convert.ToInt32(HttpContext.Current.Session["URID"]), HttpContext.Current.Session["Admin"].ToString(), strLocale);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.MainMenu = svcRt.ResultDataTable;
                    ctrl.ViewBag.LinkSite = svcRt.ResultDataSet;
                    ctrl.ViewBag.ShortLink = svcRt.ResultDataDetail["ShortLink"];
                    ctrl.ViewBag.DeptList = svcRt.ResultDataDetail["DeptList"];

                    strReturn = RequestInit(ctrl);
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }
            else
            {
                //캐쉬 사용
            }

            return strReturn;
        }

        /// <summary>
        /// 쿼리스트링 ViewBag 할당
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string RequestInit(this Controller ctrl)
        {
            string strReturn = "";
            StringBuilder sb = new StringBuilder();
            JObject jReq;

            try
            {
                //R.ct, R.ttl, R.opnode, R.ctalias, R.fdid 등등
                string req = StringHelper.SafeString(HttpContext.Current.Request["qi"], ""); //.Replace("+", " ");
                if (req != "")
                {
                    //jReq = JObject.Parse(SecurityHelper.Base64Decode(req));
                    jReq = JObject.Parse(HttpContext.Current.Server.UrlDecode(req));
                }
                else
                {
                    jReq = JObject.Parse("{}");
                }

                sb.Append("{");
                sb.Append("\"current\": {");
                sb.AppendFormat("\"urid\":\"{0}\"", HttpContext.Current.Session["URID"].ToString());
                sb.AppendFormat(",\"user\":\"{0}\"", HttpContext.Current.Session["URName"].ToString());
                sb.AppendFormat(",\"deid\":\"{0}\"", HttpContext.Current.Session["DeptID"].ToString());
                sb.AppendFormat(",\"dept\":\"{0}\"", HttpContext.Current.Session["DeptName"].ToString());
                sb.AppendFormat(",\"date\":\"{0}\"", DateTime.Now.ToString("yyyy-MM-dd"));
                sb.AppendFormat(",\"page\":\"{0}\"", HttpContext.Current.Request.Url.AbsolutePath);
                sb.AppendFormat(",\"acl\":\"{0}\"", StringHelper.SafeString(jReq["acl"], ""));
                sb.AppendFormat(",\"chief\":\"{0}\"", "");
                sb.AppendFormat(",\"operator\":\"{0}\"", "");
                sb.Append("}"); //current
                sb.AppendFormat(",\"mode\":\"{0}\"", StringHelper.SafeString(jReq["M"], ""));
                sb.AppendFormat(",\"ct\":\"{0}\"", StringHelper.SafeString(jReq["ct"], "0"));
                sb.AppendFormat(",\"ctalias\":\"{0}\"", StringHelper.SafeString(jReq["ctalias"], ""));
                sb.AppendFormat(",\"fdid\":\"{0}\"", StringHelper.SafeString(jReq["fdid"], "0"));
                sb.AppendFormat(",\"ot\":\"{0}\"", StringHelper.SafeString(jReq["ot"], ""));
                sb.AppendFormat(",\"xfalias\":\"{0}\"", StringHelper.SafeString(jReq["xfalias"], ""));
                sb.AppendFormat(",\"appid\":\"{0}\"", StringHelper.SafeString(jReq["appid"], "0"));
                sb.AppendFormat(",\"ttl\":\"{0}\"", StringHelper.SafeString(jReq["ttl"], ""));
                sb.AppendFormat(",\"opnode\":\"{0}\"", StringHelper.SafeString(jReq["opnode"], ""));
                sb.AppendFormat(",\"qi\":\"{0}\"", HttpContext.Current.Server.UrlEncode(req));
                sb.Append(",\"lv\": {");
                sb.AppendFormat("\"tgt\":\"{0}\"", "");
                sb.AppendFormat(",\"page\":\"{0}\"", "");
                sb.AppendFormat(",\"count\":\"{0}\"", "");
                sb.AppendFormat(",\"total\":\"{0}\"", "");
                sb.AppendFormat(",\"sort\":\"{0}\"", "");
                sb.AppendFormat(",\"sortdir\":\"{0}\"", "");
                sb.AppendFormat(",\"search\":\"{0}\"", "");
                sb.AppendFormat(",\"searchtext\":\"{0}\"", "");
                sb.AppendFormat(",\"start\":\"{0}\"", "");
                sb.AppendFormat(",\"end\":\"{0}\"", "");
                sb.AppendFormat(",\"basesort\":\"{0}\"", "");
                sb.AppendFormat(",\"boundary\":\"{0}\"", CommonUtils.BOUNDARY());
                sb.Append("}"); //lv (리스트뷰 요청 정보)
                sb.AppendFormat(",\"tree\":\"{0}\"", "");

                sb.Append("}");

                ctrl.ViewBag.R = JObject.Parse(sb.ToString());
            }
            catch (Exception ex)
            {
                strReturn = ex.Message;
            }

            return strReturn;
        }

        /// <summary>
        /// Ajax 값 ViewBag 할당
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string AjaxInit(this Controller ctrl)
        {
            string strReturn;

            if (ctrl.Request.IsAjaxRequest())
            {
                string req = StringHelper.SafeString(HttpContext.Current.Request["qi"], "");
                //JObject jReq = JObject.Parse(SecurityHelper.Base64Decode(req)); //CommonUtils.PostDataToJson();
                JObject jReq = JObject.Parse(HttpContext.Current.Server.UrlDecode(req)); //CommonUtils.PostDataToJson();

                if (jReq == null || jReq.Count == 0)
                {
                    strReturn = "필수값 누락!";
                }
                else
                {
                    try
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("{");
                        sb.Append("\"current\": {");
                        sb.AppendFormat("\"urid\":\"{0}\"", HttpContext.Current.Session["URID"].ToString());
                        sb.AppendFormat(",\"user\":\"{0}\"", HttpContext.Current.Session["URName"].ToString());
                        sb.AppendFormat(",\"deid\":\"{0}\"", HttpContext.Current.Session["DeptID"].ToString());
                        sb.AppendFormat(",\"dept\":\"{0}\"", HttpContext.Current.Session["DeptName"].ToString());
                        sb.AppendFormat(",\"date\":\"{0}\"", DateTime.Now.ToString("yyyy-MM-dd"));
                        sb.AppendFormat(",\"page\":\"{0}\"", HttpContext.Current.Request.Url.AbsolutePath);
                        sb.AppendFormat(",\"acl\":\"{0}\"", StringHelper.SafeString(jReq["acl"], ""));
                        sb.AppendFormat(",\"chief\":\"{0}\"", "");
                        sb.AppendFormat(",\"operator\":\"{0}\"", "");
                        sb.Append("}"); //current
                        sb.AppendFormat(",\"mode\":\"{0}\"", StringHelper.SafeString(jReq["M"], ""));
                        sb.AppendFormat(",\"ct\":\"{0}\"", StringHelper.SafeString(jReq["ct"], "0"));
                        sb.AppendFormat(",\"ctalias\":\"{0}\"", StringHelper.SafeString(jReq["ctalias"], ""));
                        sb.AppendFormat(",\"fdid\":\"{0}\"", StringHelper.SafeString(jReq["fdid"], "0"));
                        sb.AppendFormat(",\"ot\":\"{0}\"", StringHelper.SafeString(jReq["ot"], ""));
                        sb.AppendFormat(",\"xfalias\":\"{0}\"", StringHelper.SafeString(jReq["xfalias"], ""));
                        sb.AppendFormat(",\"appid\":\"{0}\"", StringHelper.SafeString(jReq["appid"], "0"));
                        sb.AppendFormat(",\"ttl\":\"{0}\"", StringHelper.SafeString(jReq["ttl"], ""));
                        sb.AppendFormat(",\"opnode\":\"{0}\"", StringHelper.SafeString(jReq["opnode"], ""));
                        sb.AppendFormat(",\"qi\":\"{0}\"", HttpContext.Current.Server.UrlEncode(req));
                        sb.Append(",\"lv\": {");
                        sb.AppendFormat("\"tgt\":\"{0}\"", jReq["tgt"].ToString());
                        sb.AppendFormat(",\"page\":\"{0}\"", jReq["page"].ToString());
                        sb.AppendFormat(",\"count\":\"{0}\"", jReq["count"].ToString());
                        sb.AppendFormat(",\"total\":\"{0}\"", "");
                        sb.AppendFormat(",\"sort\":\"{0}\"", jReq["sort"].ToString());
                        sb.AppendFormat(",\"sortdir\":\"{0}\"", jReq["sortdir"].ToString());
                        sb.AppendFormat(",\"search\":\"{0}\"", jReq["search"].ToString());
                        sb.AppendFormat(",\"searchtext\":\"{0}\"", jReq["searchtext"].ToString());
                        sb.AppendFormat(",\"start\":\"{0}\"", jReq["start"].ToString());
                        sb.AppendFormat(",\"end\":\"{0}\"", jReq["end"].ToString());
                        sb.AppendFormat(",\"basesort\":\"{0}\"", jReq["basesort"].ToString());
                        sb.AppendFormat(",\"boundary\":\"{0}\"", jReq["boundary"].ToString());
                        sb.Append("}"); //lv (리스트뷰 요청 정보)
                        sb.Append("}");

                        ctrl.ViewBag.R = JObject.Parse(sb.ToString());

                        strReturn = "";
                    }
                    catch (Exception ex)
                    {
                        strReturn = ex.Message;
                    }
                }
            }
            else
            {
                strReturn = "잘못된 경로로 접근했습니다!";
            }
            return strReturn;
        }

        /// <summary>
        /// 조직도 트리구조 반환
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static JObject OrgTree(ZumNet.Framework.Core.ServiceResult data)
        {
            string sOpenNode = data.ResultDataDetail["openNode"].ToString();
            string sIconType;

            StringBuilder sb = new StringBuilder();
            sb.Append("{");
            sb.AppendFormat("selected:\"{0}\"", sOpenNode);
            sb.Append(",data:[");

            int i = 0;
            string[] v = sOpenNode.Split(';');

            foreach (DataRow row in data.ResultDataRowCollection)
            {
                if (row["NodeLevel"].ToString() == "0")
                {
                    sIconType = "root";
                }
                else
                {
                    sIconType = "";
                }

                if (i > 0) { sb.Append(",{"); }
                else { sb.Append("{"); }

                sb.AppendFormat("id:\"{0}\"", row["GR_ID"].ToString());
                sb.AppendFormat(",parent:\"{0}\"", row["MemberOf"].ToString() == "0" ? "#" : row["MemberOf"].ToString());
                sb.AppendFormat(",text:\"{0}\"", row["DisplayName"].ToString());
                //sb.AppendFormat(",icon:\"{0}\"", "");
                sb.AppendFormat(",type:\"{0}\"", sIconType);

                if (v.Contains(row["GR_ID"].ToString()))
                {
                    if (v[v.Length - 1] == row["GR_ID"].ToString())
                    {
                        sb.Append(",state:{opened:true,disabled:false,selected:true}");
                    }
                    else
                    {
                        sb.Append(",state:{opened:true,disabled:false,selected:false}");
                    }
                }
                else
                {
                    sb.Append(",state:{opened:false,disabled:false,selected:false}");
                }
                sb.Append(",li_attr:{");
                sb.AppendFormat("level:\"{0}\"", row["NodeLevel"].ToString());
                sb.AppendFormat(",gralias:\"{0}\"", row["GRAlias"].ToString());
                sb.AppendFormat(",policy:\"{0}\"", row["Policy"].ToString());
                sb.AppendFormat(",history:\"{0}\"", row["HasHistory"].ToString());
                sb.AppendFormat(",inuse:\"{0}\"", row["InUse"].ToString());
                sb.AppendFormat(",hasmember:\"{0}\"", row["HasMember"].ToString());
                sb.AppendFormat(",rcv:\"{0}\"", row["Reserved1"].ToString());
                sb.Append("}");
                sb.Append(",a_attr:{}");
                sb.Append("}");

                i++;
            }
            sb.Append("]");
            sb.Append("}");

            return JObject.Parse(sb.ToString());
        }
    }
    #endregion
}