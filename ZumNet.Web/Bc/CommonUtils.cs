using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    /// <summary>
    /// 공통 유틸 클래스
    /// </summary>
    public class CommonUtils
    {
        //구 버전 암복호화 키값
        private const string _vectorText = "covision";
        private const string _keyText = "pusanbankkeytext";

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
        /// <param name="curYear"></param>
        /// <param name="sy"></param>
        /// <returns></returns>
        public static string OptionYear(int curYear, int sy)
        {
            string strReturn = "";
            for (int i = curYear; i >= sy; i--)
            {
                if (i == curYear) strReturn += String.Format("<option value=\"{0}\" selected=\"selected\">{0}년</option>", i.ToString());
                else strReturn += String.Format("<option value=\"{0}\">{0}년</option>", i.ToString());
            }
            return strReturn;
        }

        /// <summary>
        /// 년도 구성
        /// </summary>
        /// <param name="start">시작년도</param>
        /// <param name="end">종료년도</param>
        /// <param name="current">선택년도</param>
        /// <returns></returns>
        public static string OptionYear(int start, int end, int current)
        {
            string strReturn = "";
            for (int i = end; i >= start; i--)
            {
                if (i == current) strReturn += String.Format("<option value=\"{0}\" selected=\"selected\">{0}년</option>", i.ToString());
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

                sb.AppendFormat("<li><a href=\"javascript:\" data-val=\"{0}:00\">{0}:00</a></li>", sH);
                if (i < iTo) sb.AppendFormat("<li><a href=\"javascript:\" data-val=\"{0}:30\">{0}:30</a></li>", sH);
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
            string strReturn = exDate;

            if (date != null)
            {
                if (date != "")
                {
                    try
                    {
                        DateTime d = Convert.ToDateTime(date);
                        if (d != null) if (DateTime.Compare(d, Convert.ToDateTime("1900-01-01")) > 0 && DateTime.Compare(d, Convert.ToDateTime("2999-01-01")) < 0) strReturn = d.ToString(format);
                    }
                    catch
                    {
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
            return s.Replace(" ", "&nbsp;").Replace("\n", "<br />");
        }

        /// <summary>
        /// 첨부파일 크기 변환
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string StrFileSize(string s)
        {
            string rt = "";
            if (s == "")
            {
                rt = "N/A";
            }
            else
            {
                double v = StringHelper.SafeDouble(s);
                if (v < 1024) rt = v.ToString("n0") + "B";
                else
                {
                    v = v / 1024;
                    if (v < 1024) rt = v.ToString("n0") + "KB";
                    else
                    {
                        v = v / 1024;
                        if (v < 1024) rt = v.ToString("n0") + "MB";
                        else
                        {
                            v = v / 1024;
                            rt = v.ToString("n0") + "GB";
                        }

                    }
                }
            }
            return rt;
        }
        #endregion

        #region [파일 아이콘 이미지/클래스 반환]
        /// <summary>
        /// 파일확장자 클래스 반환
        /// </summary>
        /// <param name="ext"></param>
        /// <returns></returns>
        public static string GetFileExt(string ext)
        {
            string rt = "";

            switch (ext.ToLower())
            {
                case "mht":
                    rt = "far fa-file-alt text-danger";
                    break;

                case "txt":
                    rt = "far fa-file-alt text-secondary";
                    break;

                case "zip":
                    rt = "far fa-file-archive text-purple";
                    break;

                case "doc":
                case "docx":
                    rt = "far fa-file-word text-blue";
                    break;

                case "xls":
                case "xlsx":
                    rt = "far fa-file-excel text-teal";
                    break;

                case "ppt":
                case "pptx":
                    rt = "far fa-file-powerpoint text-danger";
                    break;

                case "pdf":
                    rt = "far fa-file-pdf text-danger";
                    break;

                case "png":
                case "bmp":
                case "jpg":
                case "gif":
                    rt = "far fa-file-image text-twitter";
                    break;

                case "avi":
                case "mkv":
                case "mov":
                case "mp4":
                case "mpg":
                case "wmv":
                    rt = "far fa-file-video text-facebook";
                    break;

                case "mp3":
                case "ogg":
                case "wma":
                case "wav":
                    rt = "far fa-file-audio text-secondary";
                    break;

                default:
                    rt = "far fa-file text-secondary";
                    break;
            }

            return rt;
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
                else if (category.ToLower() == "orgmap") sName = "orgLvCount";
                else if (category.ToLower() == "cost") sName = "costLvCount"; //모델별원가, 개발원가
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
            else if (category.ToLower() == "orgmap") sName = "orgLvCount";
            else if (category.ToLower() == "cost") sName = "costLvCount"; //모델별원가, 개발원가
            else sName = "bbsLvCount";

            HttpCookie ck = HttpContext.Current.Request.Cookies[sName];

            if (category.ToLower() == "cost") return ck != null ? ZumNet.Framework.Util.StringHelper.SafeInt(ck.Value, 7) : 7;
            else return ck != null ? ZumNet.Framework.Util.StringHelper.SafeInt(ck.Value, 20) : 20;
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

        #region [구 버전 비밀번호 암복호화]
        /// <summary>
		/// 텍스트 암호화
		/// </summary>
		/// <param name="strText"></param>
		/// <returns></returns>
		public static string SetEncrypt(string strText)
        {
            string strReturn = "";

            try
            {
                Phs.Framework.Security.Encryptor enc = new Phs.Framework.Security.Encryptor(Phs.Framework.Security.EncryptionAlgorithm.TripleDes);
                enc.IV = Encoding.ASCII.GetBytes(_vectorText);
                byte[] plainText = Encoding.ASCII.GetBytes(strText);
                byte[] key = Encoding.ASCII.GetBytes(_keyText);
                byte[] cipherText = enc.Encrypt(plainText, key);

                strReturn = Convert.ToBase64String(cipherText);
            }
            catch (Exception ex)
            {
                Framework.Exception.ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }

            return strReturn;
        }

        /// <summary>
        /// 텍스트 복호화
        /// </summary>
        /// <param name="strText"></param>
        /// <returns></returns>
        public static string SetDecrypt(string strText)
        {
            string strReturn = "";

            try
            {
                Phs.Framework.Security.Decryptor dec = new Phs.Framework.Security.Decryptor(Phs.Framework.Security.EncryptionAlgorithm.TripleDes);
                dec.IV = Encoding.ASCII.GetBytes(_vectorText);
                byte[] key = Encoding.ASCII.GetBytes(_keyText);
                byte[] plainText = dec.Decrypt(Convert.FromBase64String(strText), key);

                strReturn = Encoding.ASCII.GetString(plainText);
            }
            catch (Exception ex)
            {
                Framework.Exception.ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }

            return strReturn;
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
        #region [전체 새로고침 되는 페이지 초기 데이터 설정]
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
                    svcRt = com.GetMenuTop(Convert.ToInt32(HttpContext.Current.Session["DNID"]), Convert.ToInt32(HttpContext.Current.Session["URID"]), HttpContext.Current.Session["Admin"].ToString(), HttpContext.Current.Session["UseWorkTime"].ToString(), strLocale);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.MainMenu = svcRt.ResultDataTable;
                    ctrl.ViewBag.LinkSite = svcRt.ResultDataSet;
                    ctrl.ViewBag.ShortLink = svcRt.ResultDataDetail["ShortLink"];
                    ctrl.ViewBag.DeptList = svcRt.ResultDataDetail["DeptList"];
                    //ctrl.ViewBag.WorkStatus = svcRt.ResultDataDetail["WorkStatus"];

                    strReturn = RequestInit(ctrl, svcRt.ResultDataDetail["WorkStatus"].ToString());
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
        #endregion

        #region [쿼리스트링 할당]
        /// <summary>
        /// 쿼리스트링 ViewBag 할당
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string RequestInit(this Controller ctrl, string workStatus)
        {
            string strReturn = "";

            JObject jReq;
            JObject jV; //Response Data

            try
            {
                //R.ct, R.ttl, R.opnode, R.ctalias, R.fdid 등등
                string req = StringHelper.SafeString(HttpContext.Current.Request["qi"], ""); //.Replace("+", " ");
                if (req != "")
                {
                    jReq = JObject.Parse(SecurityHelper.Base64Decode(req)); //req.Replace(" ", "+") => urlencoding 안 했을 경우 필요
                    //jReq = JObject.Parse(HttpContext.Current.Server.UrlDecode(req));
                }
                else
                {
                    jReq = JObject.Parse("{}");
                }

                DateTime nowDate = DateTime.Now;
                string workDate = nowDate.Hour < 6 ? nowDate.AddDays(-1).ToString("yyyy-MM-dd") : nowDate.ToString("yyyy-MM-dd");

                //StringBuilder sb = new StringBuilder();
                //sb.Append("{");
                //sb.Append("\"current\": {");
                //sb.AppendFormat("\"urid\":\"{0}\"", HttpContext.Current.Session["URID"].ToString());
                //sb.AppendFormat(",\"user\":\"{0}\"", HttpContext.Current.Session["URName"].ToString());
                //sb.AppendFormat(",\"deptid\":\"{0}\"", HttpContext.Current.Session["DeptID"].ToString());
                //sb.AppendFormat(",\"dept\":\"{0}\"", HttpContext.Current.Session["DeptName"].ToString());
                //sb.AppendFormat(",\"date\":\"{0}\"", nowDate.ToString("yyyy-MM-dd"));
                //sb.AppendFormat(",\"workdate\":\"{0}\"", workDate); //근무관리
                //sb.AppendFormat(",\"page\":\"{0}\"", HttpContext.Current.Request.Url.AbsolutePath);
                //sb.AppendFormat(",\"acl\":\"{0}\"", StringHelper.SafeString(jReq["acl"]));
                //sb.AppendFormat(",\"chief\":\"{0}\"", "");
                //sb.AppendFormat(",\"operator\":\"{0}\"", "");

                //if (workStatus != "" && workStatus.IndexOf(';') != -1)
                //{
                //    string[] v = workStatus.Split(';');
                //    if (v[0] == "" || v[0] == "A" || v[0] == "S" || v[0] == "U" || v[0] == "N" || v[0] == "Z")
                //    {
                //        sb.AppendFormat(",\"ws\":\"{0}\"", "N"); //퇴근 후 재로그인시 근무중으로 표시
                //    }
                //    else
                //    {
                //        sb.AppendFormat(",\"ws\":\"{0}\"", v[0]);
                //    }
                //    sb.AppendFormat(",\"intime\":\"{0}\"", v[1]);
                //    sb.AppendFormat(",\"outtime\":\"{0}\"", v[2]);
                //}
                //else
                //{
                //    sb.AppendFormat(",\"ws\":\"{0}\"", workStatus); //근무현황, N/A일 경우 => 해당없음
                //    sb.AppendFormat(",\"intime\":\"{0}\"", ""); //출근시각
                //    sb.AppendFormat(",\"outtime\":\"{0}\"", ""); //퇴근시각
                //}

                //sb.Append("}"); //current
                //sb.AppendFormat(",\"mode\":\"{0}\"", StringHelper.SafeString(jReq["M"]));
                //sb.AppendFormat(",\"ct\":\"{0}\"", StringHelper.SafeString(jReq["ct"], "0"));
                //sb.AppendFormat(",\"ctalias\":\"{0}\"", StringHelper.SafeString(jReq["ctalias"]));
                //sb.AppendFormat(",\"fdid\":\"{0}\"", StringHelper.SafeString(jReq["fdid"], "0"));
                //sb.AppendFormat(",\"ot\":\"{0}\"", StringHelper.SafeString(jReq["ot"]));
                //sb.AppendFormat(",\"alias\":\"{0}\"", StringHelper.SafeString(jReq["alias"])); //Report용
                //sb.AppendFormat(",\"xfalias\":\"{0}\"", StringHelper.SafeString(jReq["xfalias"]));
                //sb.AppendFormat(",\"appid\":\"{0}\"", StringHelper.SafeString(jReq["appid"], "0"));
                //sb.AppendFormat(",\"ttl\":\"{0}\"", HttpContext.Current.Server.HtmlEncode(StringHelper.SafeString(jReq["ttl"])));
                //sb.AppendFormat(",\"opnode\":\"{0}\"", StringHelper.SafeString(jReq["opnode"]));
                //sb.AppendFormat(",\"ft\":\"{0}\"", StringHelper.SafeString(jReq["ft"])); //Report용 formtable
                //sb.AppendFormat(",\"qi\":\"{0}\"", "");
                ////sb.AppendFormat(",\"qi\":\"{0}\"", "");
                //sb.Append(",\"lv\": {");
                //sb.AppendFormat("\"tgt\":\"{0}\"", StringHelper.SafeString(jReq["tgt"]));
                //sb.AppendFormat(",\"page\":\"{0}\"", StringHelper.SafeString(jReq["page"]));
                //sb.AppendFormat(",\"count\":\"{0}\"", StringHelper.SafeString(jReq["count"]));
                //sb.AppendFormat(",\"total\":\"{0}\"", "");
                //sb.AppendFormat(",\"sort\":\"{0}\"", StringHelper.SafeString(jReq["sort"]));
                //sb.AppendFormat(",\"sortdir\":\"{0}\"", StringHelper.SafeString(jReq["sortdir"]));
                //sb.AppendFormat(",\"search\":\"{0}\"", StringHelper.SafeString(jReq["search"]));
                //sb.AppendFormat(",\"searchtext\":\"{0}\"", StringHelper.SafeString(jReq["searchtext"]));
                //sb.AppendFormat(",\"start\":\"{0}\"", StringHelper.SafeString(jReq["start"]));
                //sb.AppendFormat(",\"end\":\"{0}\"", StringHelper.SafeString(jReq["end"]));
                //sb.AppendFormat(",\"basesort\":\"{0}\"", StringHelper.SafeString(jReq["basesort"]));
                //sb.AppendFormat(",\"boundary\":\"{0}\"", CommonUtils.BOUNDARY());
                //sb.Append("}"); //lv (리스트뷰 요청 정보)
                //sb.AppendFormat(",\"tree\":\"{0}\"", "");

                //sb.Append("}");

                //ctrl.ViewBag.R = JObject.Parse(sb.ToString());

                //2021-11-18 위 StringBuilder 막고 아래 json 파일 이용으로 변경
                using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath("~/Content/Json/init.json")))
                {
                    jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                jV["current"]["user"] = HttpContext.Current.Session["URName"].ToString();
                jV["current"]["urid"] = HttpContext.Current.Session["URID"].ToString();
                jV["current"]["urcn"] = HttpContext.Current.Session["LogonID"].ToString();
                jV["current"]["dept"] = HttpContext.Current.Session["DeptName"].ToString();
                jV["current"]["deptid"] = HttpContext.Current.Session["DeptID"].ToString();
                jV["current"]["deptcd"] = HttpContext.Current.Session["DeptAlias"].ToString();

                jV["current"]["date"] = nowDate.ToString("yyyy-MM-dd");
                jV["current"]["workdate"] = workDate; //근무관리
                jV["current"]["page"] = HttpContext.Current.Request.Url.AbsolutePath;
                jV["current"]["acl"] = StringHelper.SafeString(jReq["acl"]); //폴더, 게시판 권한
                jV["current"]["appacl"] = StringHelper.SafeString(jReq["appacl"]); //게시물권한
                jV["current"]["chief"] = "";
                jV["current"]["operator"] = "";

                if (workStatus != "" && workStatus.IndexOf(';') != -1)
                {
                    string[] v = workStatus.Split(';');
                    if (v[0] == "" || v[0] == "A" || v[0] == "S" || v[0] == "U" || v[0] == "N" || v[0] == "Z")
                    {
                        jV["current"]["ws"] = "N"; //퇴근 후 재로그인시 근무중으로 표시
                    }
                    else
                    {
                        jV["current"]["ws"] = v[0];
                    }
                    jV["current"]["intime"] = v[1];
                    jV["current"]["outtime"] = v[2];
                }
                else
                {
                    jV["current"]["ws"] = workStatus; //근무현황, N/A일 경우 => 해당없음
                    jV["current"]["intime"] = ""; //출근시각
                    jV["current"]["outtime"] = ""; //퇴근시각
                }

                jV["mode"] = StringHelper.SafeString(jReq["M"]);
                jV["wnd"] = StringHelper.SafeString(jReq["wnd"]); // 빈값(내부), popup(새창), modal(모달창)
                jV["domain"] = HttpContext.Current.Session["MainSuffix"].ToString();
                jV["ct"] = StringHelper.SafeString(jReq["ct"], "0");
                jV["ctalias"] = StringHelper.SafeString(jReq["ctalias"]);
                jV["fdid"] = StringHelper.SafeString(jReq["fdid"], "0");
                jV["ot"] = StringHelper.SafeString(jReq["ot"]);
                jV["alias"] = StringHelper.SafeString(jReq["alias"]); //Report용
                jV["xfalias"] = StringHelper.SafeString(jReq["xfalias"]);
                jV["appid"] = StringHelper.SafeString(jReq["appid"], "0");
                jV["ttl"] = StringHelper.SafeString(jReq["ttl"]);
                jV["opnode"] = StringHelper.SafeString(jReq["opnode"]);
                jV["ft"] = StringHelper.SafeString(jReq["ft"]);
                jV["qi"] = "";

                jV["lv"]["tgt"] = StringHelper.SafeString(jReq["tgt"]);
                jV["lv"]["page"] = StringHelper.SafeString(jReq["page"]);
                jV["lv"]["count"] = StringHelper.SafeString(jReq["count"]);
                jV["lv"]["total"] = "";
                jV["lv"]["sort"] = StringHelper.SafeString(jReq["sort"]);
                jV["lv"]["sortdir"] = StringHelper.SafeString(jReq["sortdir"]);
                jV["lv"]["search"] = StringHelper.SafeString(jReq["search"]);
                jV["lv"]["searchtext"] = StringHelper.SafeString(jReq["searchtext"]);
                jV["lv"]["start"] = StringHelper.SafeString(jReq["start"]);
                jV["lv"]["end"] = StringHelper.SafeString(jReq["end"]);
                jV["lv"]["basesort"] = StringHelper.SafeString(jReq["basesort"]);
                jV["lv"]["boundary"] = CommonUtils.BOUNDARY();

                //추가 리스트뷰 검색 조건 담기
                jV["lv"]["cd1"] = StringHelper.SafeString(jReq["cd1"]);
                jV["lv"]["cd2"] = StringHelper.SafeString(jReq["cd2"]);
                jV["lv"]["cd3"] = StringHelper.SafeString(jReq["cd3"]);
                jV["lv"]["cd4"] = StringHelper.SafeString(jReq["cd4"]);
                jV["lv"]["cd5"] = StringHelper.SafeString(jReq["cd5"]);
                jV["lv"]["cd6"] = StringHelper.SafeString(jReq["cd6"]);
                jV["lv"]["cd7"] = StringHelper.SafeString(jReq["cd7"]);
                jV["lv"]["cd8"] = StringHelper.SafeString(jReq["cd8"]);
                jV["lv"]["cd9"] = StringHelper.SafeString(jReq["cd9"]);
                jV["lv"]["cd10"] = StringHelper.SafeString(jReq["cd10"]);
                jV["lv"]["cd11"] = StringHelper.SafeString(jReq["cd11"]);
                jV["lv"]["cd12"] = StringHelper.SafeString(jReq["cd12"]);

                //개발원가견적 조건
                if (StringHelper.SafeString(jReq["ctalias"]).ToUpper() == "CE")
                {
                    jV["checkunload"] = StringHelper.SafeInt(jReq["appid"], 0) == 0 ? true : false;
                    jV["nsstatus"] = StringHelper.SafeString(jReq["nsstatus"], "0"); //2020-11-16 : 상위 포함관계, 0: 미포함, 1 : 상위정상포함, 2 : 상위반려
                    jV["rptid"] = StringHelper.SafeString(jReq["rptid"], "");
                    jV["rptmode"] = StringHelper.SafeString(jReq["rptmode"], "3"); //0 : 신규집계 시뮬, 1 : 신규집계 작성/편집, 2 : 집계 조회, 3 : 하위
                    jV["gvmode"] = "";
                }

                ctrl.ViewBag.R = jV;
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
                JObject jReq;

                if (HttpContext.Current.Request["qi"] == null)
                {
                    jReq = CommonUtils.PostDataToJson(); //인코딩 안되는 Post 경우
                }
                else
                {
                    string req = StringHelper.SafeString(HttpContext.Current.Request["qi"]);
                    jReq = JObject.Parse(SecurityHelper.Base64Decode(req)); //CommonUtils.PostDataToJson();
                                                                            //JObject jReq = JObject.Parse(HttpContext.Current.Server.UrlDecode(req)); //CommonUtils.PostDataToJson();
                }
                JObject jV; //Response Data

                if (jReq == null || jReq.Count == 0)
                {
                    strReturn = "필수값 누락!";
                }
                else
                {
                    try
                    {
                        DateTime nowDate = DateTime.Now;
                        string workDate = nowDate.Hour < 6 ? nowDate.AddDays(-1).ToString("yyyy-MM-dd") : nowDate.ToString("yyyy-MM-dd");

                        //StringBuilder sb = new StringBuilder();
                        //sb.Append("{");
                        //sb.Append("\"current\": {");
                        //sb.AppendFormat("\"urid\":\"{0}\"", HttpContext.Current.Session["URID"].ToString());
                        //sb.AppendFormat(",\"user\":\"{0}\"", HttpContext.Current.Session["URName"].ToString());
                        //sb.AppendFormat(",\"deptid\":\"{0}\"", HttpContext.Current.Session["DeptID"].ToString());
                        //sb.AppendFormat(",\"dept\":\"{0}\"", HttpContext.Current.Session["DeptName"].ToString());
                        //sb.AppendFormat(",\"date\":\"{0}\"", nowDate.ToString("yyyy-MM-dd"));
                        //sb.AppendFormat(",\"workdate\":\"{0}\"", workDate); //근무관리
                        //sb.AppendFormat(",\"page\":\"{0}\"", HttpContext.Current.Request.Url.AbsolutePath);
                        //sb.AppendFormat(",\"acl\":\"{0}\"", StringHelper.SafeString(jReq["acl"]));
                        //sb.AppendFormat(",\"chief\":\"{0}\"", "");
                        //sb.AppendFormat(",\"operator\":\"{0}\"", "");
                        //sb.Append("}"); //current
                        //sb.AppendFormat(",\"mode\":\"{0}\"", StringHelper.SafeString(jReq["M"]));
                        //sb.AppendFormat(",\"ct\":\"{0}\"", StringHelper.SafeString(jReq["ct"], "0"));
                        //sb.AppendFormat(",\"ctalias\":\"{0}\"", StringHelper.SafeString(jReq["ctalias"]));
                        //sb.AppendFormat(",\"fdid\":\"{0}\"", StringHelper.SafeString(jReq["fdid"], "0"));
                        //sb.AppendFormat(",\"ot\":\"{0}\"", StringHelper.SafeString(jReq["ot"]));
                        //sb.AppendFormat(",\"alias\":\"{0}\"", StringHelper.SafeString(jReq["alias"])); //Report용
                        //sb.AppendFormat(",\"xfalias\":\"{0}\"", StringHelper.SafeString(jReq["xfalias"]));
                        //sb.AppendFormat(",\"appid\":\"{0}\"", StringHelper.SafeString(jReq["appid"], "0"));
                        //sb.AppendFormat(",\"ttl\":\"{0}\"", HttpContext.Current.Server.HtmlEncode(StringHelper.SafeString(jReq["ttl"])));
                        //sb.AppendFormat(",\"opnode\":\"{0}\"", StringHelper.SafeString(jReq["opnode"]));
                        //sb.AppendFormat(",\"ft\":\"{0}\"", StringHelper.SafeString(jReq["ft"])); //Report용 formtable
                        //sb.AppendFormat(",\"qi\":\"{0}\"", "");
                        //sb.Append(",\"lv\": {");
                        //sb.AppendFormat("\"tgt\":\"{0}\"", StringHelper.SafeString(jReq["tgt"]));
                        //sb.AppendFormat(",\"page\":\"{0}\"", StringHelper.SafeString(jReq["page"]));
                        //sb.AppendFormat(",\"count\":\"{0}\"", StringHelper.SafeString(jReq["count"]));
                        //sb.AppendFormat(",\"total\":\"{0}\"", "");
                        //sb.AppendFormat(",\"sort\":\"{0}\"", StringHelper.SafeString(jReq["sort"]));
                        //sb.AppendFormat(",\"sortdir\":\"{0}\"", StringHelper.SafeString(jReq["sortdir"]));
                        //sb.AppendFormat(",\"search\":\"{0}\"", StringHelper.SafeString(jReq["search"]));
                        //sb.AppendFormat(",\"searchtext\":\"{0}\"", StringHelper.SafeString(jReq["searchtext"]));
                        //sb.AppendFormat(",\"start\":\"{0}\"", StringHelper.SafeString(jReq["start"]));
                        //sb.AppendFormat(",\"end\":\"{0}\"", StringHelper.SafeString(jReq["end"]));
                        //sb.AppendFormat(",\"basesort\":\"{0}\"", StringHelper.SafeString(jReq["basesort"]));
                        //sb.AppendFormat(",\"boundary\":\"{0}\"", StringHelper.SafeString(jReq["boundary"]));
                        //sb.Append("}"); //lv (리스트뷰 요청 정보)
                        //sb.Append("}");

                        //ctrl.ViewBag.R = JObject.Parse(sb.ToString());

                        //2021-11-18 위 StringBuilder 막고 아래 json 파일 이용으로 변경
                        using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath("~/Content/Json/init.json")))
                        {
                            jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                        }

                        jV["current"]["user"] = HttpContext.Current.Session["URName"].ToString();
                        jV["current"]["urid"] = HttpContext.Current.Session["URID"].ToString();
                        jV["current"]["urcn"] = HttpContext.Current.Session["LogonID"].ToString();
                        jV["current"]["dept"] = HttpContext.Current.Session["DeptName"].ToString();
                        jV["current"]["deptid"] = HttpContext.Current.Session["DeptID"].ToString();
                        jV["current"]["deptcd"] = HttpContext.Current.Session["DeptAlias"].ToString();

                        jV["current"]["date"] = nowDate.ToString("yyyy-MM-dd");
                        jV["current"]["workdate"] = workDate; //근무관리
                        jV["current"]["page"] = HttpContext.Current.Request.Url.AbsolutePath;
                        jV["current"]["acl"] = StringHelper.SafeString(jReq["acl"]); //폴더, 게시판 권한
                        jV["current"]["appacl"] = StringHelper.SafeString(jReq["appacl"]); //게시물권한
                        jV["current"]["chief"] = "";
                        jV["current"]["operator"] = "";

                        jV["mode"] = StringHelper.SafeString(jReq["M"]);
                        jV["wnd"] = StringHelper.SafeString(jReq["wnd"]); // 빈값(내부), popup(새창), modal(모달창)
                        jV["domain"] = HttpContext.Current.Session["MainSuffix"].ToString();
                        jV["ct"] = StringHelper.SafeString(jReq["ct"], "0");
                        jV["ctalias"] = StringHelper.SafeString(jReq["ctalias"]);
                        jV["fdid"] = StringHelper.SafeString(jReq["fdid"], "0");
                        jV["ot"] = StringHelper.SafeString(jReq["ot"]);
                        jV["alias"] = StringHelper.SafeString(jReq["alias"]); //Report용
                        jV["xfalias"] = StringHelper.SafeString(jReq["xfalias"]);
                        jV["appid"] = StringHelper.SafeString(jReq["appid"], "0");
                        jV["ttl"] = StringHelper.SafeString(jReq["ttl"]);
                        jV["opnode"] = StringHelper.SafeString(jReq["opnode"]);
                        jV["ft"] = StringHelper.SafeString(jReq["ft"]);
                        jV["qi"] = "";

                        jV["lv"]["tgt"] = StringHelper.SafeString(jReq["tgt"]);
                        jV["lv"]["page"] = StringHelper.SafeString(jReq["page"]);
                        jV["lv"]["count"] = StringHelper.SafeString(jReq["count"]);
                        jV["lv"]["total"] = "";
                        jV["lv"]["sort"] = StringHelper.SafeString(jReq["sort"]);
                        jV["lv"]["sortdir"] = StringHelper.SafeString(jReq["sortdir"]);
                        jV["lv"]["search"] = StringHelper.SafeString(jReq["search"]);
                        jV["lv"]["searchtext"] = StringHelper.SafeString(jReq["searchtext"]);
                        jV["lv"]["start"] = StringHelper.SafeString(jReq["start"]);
                        jV["lv"]["end"] = StringHelper.SafeString(jReq["end"]);
                        jV["lv"]["basesort"] = StringHelper.SafeString(jReq["basesort"]);
                        jV["lv"]["boundary"] = StringHelper.SafeString(jReq["boundary"]);

                        //추가 리스트뷰 검색 조건 담기
                        jV["lv"]["cd1"] = StringHelper.SafeString(jReq["cd1"]);
                        jV["lv"]["cd2"] = StringHelper.SafeString(jReq["cd2"]);
                        jV["lv"]["cd3"] = StringHelper.SafeString(jReq["cd3"]);
                        jV["lv"]["cd4"] = StringHelper.SafeString(jReq["cd4"]);
                        jV["lv"]["cd5"] = StringHelper.SafeString(jReq["cd5"]);
                        jV["lv"]["cd6"] = StringHelper.SafeString(jReq["cd6"]);
                        jV["lv"]["cd7"] = StringHelper.SafeString(jReq["cd7"]);
                        jV["lv"]["cd8"] = StringHelper.SafeString(jReq["cd8"]);
                        jV["lv"]["cd9"] = StringHelper.SafeString(jReq["cd9"]);
                        jV["lv"]["cd10"] = StringHelper.SafeString(jReq["cd10"]);
                        jV["lv"]["cd11"] = StringHelper.SafeString(jReq["cd11"]);
                        jV["lv"]["cd12"] = StringHelper.SafeString(jReq["cd12"]);

                        //개발원가견적 조건
                        if (StringHelper.SafeString(jReq["ctalias"]).ToUpper() == "CE")
                        {
                            jV["checkunload"] = StringHelper.SafeInt(jReq["appid"], 0) == 0 ? true : false;
                            jV["nsstatus"] = StringHelper.SafeString(jReq["nsstatus"], "0"); //2020-11-16 : 상위 포함관계, 0: 미포함, 1 : 상위정상포함, 2 : 상위반려
                            jV["rptid"] = StringHelper.SafeString(jReq["rptid"], "");
                            jV["rptmode"] = StringHelper.SafeString(jReq["rptmode"], "3"); //0 : 신규집계 시뮬, 1 : 신규집계 작성/편집, 2 : 집계 조회, 3 : 하위
                            jV["gvmode"] = "";
                        }

                        ctrl.ViewBag.R = jV;

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
                strReturn = Resources.Global.Auth_InvalidPath; // "잘못된 경로로 접근했습니다!";
            }
            return strReturn;
        }
        #endregion

        #region [조직도, 사이트맵]
        /// <summary>
        /// 조직도 트리구조 반환
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static string OrgTreeString(ZumNet.Framework.Core.ServiceResult data)
        {
            string sOpenNode = data.ResultDataDetail["openNode"].ToString();
            string sIconType;

            StringBuilder sb = new StringBuilder();
            sb.Append("{");
            sb.AppendFormat("\"selected\":\"{0}\"", sOpenNode);
            sb.Append(",\"data\":[");

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

                sb.AppendFormat("\"id\":\"{0}\"", row["GR_ID"].ToString());
                sb.AppendFormat(",\"parent\":\"{0}\"", row["MemberOf"].ToString() == "0" ? "#" : row["MemberOf"].ToString());
                sb.AppendFormat(",\"text\":\"{0}\"", row["DisplayName"].ToString());
                //sb.AppendFormat(",icon:\"{0}\"", "");
                sb.AppendFormat(",\"type\":\"{0}\"", sIconType);

                if (v.Contains(row["GR_ID"].ToString()))
                {
                    if (v[v.Length - 1] == row["GR_ID"].ToString())
                    {
                        sb.Append(",\"state\":{\"opened\":true,\"disabled\":false,\"selected\":true}");
                    }
                    else
                    {
                        sb.Append(",\"state\":{\"opened\":true,\"disabled\":false,\"selected\":false}");
                    }
                }
                else
                {
                    sb.Append(",\"state\":{\"opened\":false,\"disabled\":false,\"selected\":false}");
                }
                sb.Append(",\"li_attr\":{");
                sb.AppendFormat("\"level\":\"{0}\"", row["NodeLevel"].ToString());
                sb.AppendFormat(",\"gralias\":\"{0}\"", row["GRAlias"].ToString());
                sb.AppendFormat(",\"policy\":\"{0}\"", row["Policy"].ToString());
                sb.AppendFormat(",\"history\":\"{0}\"", row["HasHistory"].ToString());
                sb.AppendFormat(",\"inuse\":\"{0}\"", row["InUse"].ToString());
                sb.AppendFormat(",\"hasmember\":\"{0}\"", row["HasMember"].ToString());
                sb.AppendFormat(",\"rcv\":\"{0}\"", row["Reserved1"].ToString());
                sb.Append("}");
                sb.Append(",\"a_attr\":{}");
                sb.Append("}");

                i++;
            }
            sb.Append("]");
            sb.Append("}");

            return sb.ToString();
        }

        /// <summary>
        /// 조직도 트리구조 반환
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static JObject OrgTree(ZumNet.Framework.Core.ServiceResult data)
        {
            return JObject.Parse(OrgTreeString(data));
        }

        /// <summary>
        /// 폴더 사이트맵 경로 가져오기
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="ctId"></param>
        /// <param name="fdId"></param>
        /// <param name="openNode"></param>
        /// <returns></returns>
        public static string SiteMap(this Controller ctrl, int ctId, int fdId, string openNode)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            try
            {
                if (openNode == "" || openNode.IndexOf('.') < 0) openNode = "0.0." + fdId.ToString(); //folderid만 넘어오는 경우

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetSiteMapNavigation(Convert.ToInt32(HttpContext.Current.Session["DNID"]), ctId, openNode);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    string sSitePath = "";
                    string sFolderTitle = "";
                    string[] vSiteMap = svcRt.ResultDataString.Split(new char[] { '' });
                    for (int i = 0; i < vSiteMap.Length; i++)
                    {
                        string[] s = vSiteMap[i].Split(new char[] { '' });
                        sSitePath += (sSitePath == "") ? s[1] : " > " + s[1];

                        if (i > 0) sFolderTitle += (sFolderTitle == "") ? s[1] : " / " + s[1];
                    }

                    ctrl.ViewBag.SiteMap = sSitePath;
                    ctrl.ViewBag.R.ttl = sFolderTitle;
                }
                else
                {
                    strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                strReturn = ex.Message;
            }

            return strReturn;
        }

        #endregion

        #region [메뉴별 초기 설정]
        /// <summary>
        /// 결재 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="chargerCheck"></param>
        /// <param name="curBox"></param>
        /// <returns></returns>
        public static string EAInit(this Controller ctrl, bool chargerCheck, string curBox)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            if (chargerCheck)
            {
                //담당 체크
                using (ZumNet.BSL.FlowBiz.WorkList wkList = new BSL.FlowBiz.WorkList())
                {
                    svcRt = wkList.GetMenuConfig(Convert.ToInt32(HttpContext.Current.Session["DNID"]), Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(HttpContext.Current.Session["DeptID"]));
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.FormCharger = svcRt.ResultDataDetail["FormCharger"];
                    ctrl.ViewBag.RcvManager = svcRt.ResultDataDetail["RcvManager"];
                    ctrl.ViewBag.SharedFolder = svcRt.ResultDataRowCollection;
                }
                else
                {
                    //에러페이지
                    return svcRt.ResultMessage;
                }
            }

            try
            {
                string sDel = "/";
                string[,] vBox = {
                    //type, node, location, actrole, query, basesort, 문서함명, basesort명, count여부, bold여부
                    { "u", "node.do", "do", "", "do" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReqDate", Resources.EA.BoxToDo, Resources.Global.Date_Request, "Y", "Y" },
                    { "u", "node.ep", "ep", "", "ep" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "PIStart", Resources.EA.BoxExpected, Resources.Global.Date_Draft, "Y", "Y" },
                    { "u", "node.wt", "wt", "", "wt" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "CreateDate", Resources.EA.BoxWaiting, Resources.Global.Date_Sent, "Y", "Y" },
                    { "u", "node.av", "av", "", "av" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReceivedDate", Resources.EA.BoxToApprove, Resources.Global.Date_Receive, "Y", "Y" },
                    { "u", "node.go", "go", "", "go" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "CompletedDate", Resources.EA.BoxInProcess, Resources.Global.Date_Approve, "Y", "Y" },
                    { "u", "node.cf", "cf", "_cf", "cf" + sDel + "_cf" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReceivedDate", Resources.EA.BoxToConfirm, Resources.Global.Date_Receive, "Y", "" },
                    { "u", "node.dl", "dl", "_dl", "dl" + sDel + "_dl" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReceivedDate", Resources.EA.BoxDistribued, Resources.Global.Date_Receive, "Y", "" },
                    { "u", "node.cm", "cm", "", "cm" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "CompletedDate", Resources.EA.BoxCompleted, Resources.Global.Date_Approve, "", "" },
                    { "u", "node.rj", "rj", "", "rj" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "CompletedDate", Resources.EA.BoxReturn, Resources.Global.Date_Return, "Y", "" },
                    { "u", "node.ps", "ps", "", "ps" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReceivedDate", Resources.EA.BoxViewLater, Resources.Global.Date_Receive, "", "" },
                    { "u", "node.re", "re", "", "re" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "ReceivedDate", Resources.EA.BoxReference, Resources.Global.Date_Receive, "Y", "" },
                    { "u", "node.wd", "wd", "", "wd" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "PIEnd", Resources.EA.BoxWithdraw, Resources.Global.Date_Withdraw, "", "" },
                    { "u", "node.te", "te", "", "te" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(), "CreateDate", Resources.EA.BoxSaved, Resources.Global.Date_Created, "", "" },

                    { "d", "node.as", "as", "__r", "as" + sDel + "__r" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "__r", "ReceivedDate", Resources.EA.BoxAssigned, Resources.Global.Date_Receipt, "Y", "Y" },
                    { "d", "node.__r", "__r", "__r", "__r" + sDel + "__r" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "__r", "ReceivedDate", Resources.EA.BoxReceived, Resources.Global.Date_Receipt, "Y", "Y" },
                    { "d", "node._s", "_s", "_s", "_s" + sDel + "_s" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "_s", "CompletedDate", Resources.EA.BoxSent, Resources.Global.Date_Send, "", "" },
                    { "d", "node._a", "_a", "_a", "_a" + sDel + "_a" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "_a", "PIEnd", Resources.EA.BoxCompleted, Resources.Global.Date_Complete, "", "" },
                    { "d", "node._re", "_re", "_re", "_re" + sDel + "_re" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "_re", "ReceivedDate", Resources.EA.BoxReference, Resources.Global.Date_Receipt, "Y", "" },
                    { "d", "node._dl", "dl", "_dl", "dl" + sDel + "_dl" + sDel + HttpContext.Current.Session["DeptID"].ToString() + "_dl", "ReceivedDate", Resources.EA.BoxDistribued, Resources.Global.Date_Receipt, "Y", "" }
                };

                if (curBox == "" || curBox.IndexOf(sDel) < 0)
                {
                    curBox = vBox[3, 4]; //"av" + sDel + "" + sDel + HttpContext.Current.Session["URID"].ToString(); //기본 결재함
                    ctrl.ViewBag.R["opnode"] = curBox;
                    ctrl.ViewBag.R["ttl"] = vBox[3, 6];
                }
                string[] vQuery = curBox.Split(new string[] { sDel }, StringSplitOptions.None);
                string[] vCurrentBox = new string[10];

                for (int i = 0; i < vBox.GetLength(0); i++)
                {
                    if (vQuery[0] == vBox[i, 2] && vQuery[1] == vBox[i, 3]) //location, actrole
                    {
                        for (int j = 0; j < vCurrentBox.Length; j++)
                        {
                            vCurrentBox[j] = vBox.GetValue(i, j).ToString();
                        }
                        break;
                    }
                }

                ctrl.ViewBag.Box = vBox;
                ctrl.ViewBag.CurBox = vCurrentBox;
                ctrl.ViewBag.PartID = vQuery[2];
            }
            catch (Exception ex)
            {
                strReturn = ex.Message;
            }

            return strReturn;
        }

        /// <summary>
        /// 결재 양식 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string EFormInit(this Controller ctrl)
        {
            ZumNet.DAL.FlowDac.EApprovalDac eaDac = null;
            ZumNet.DAL.FlowDac.ProcessDac procDac = null;
            ZumNet.Framework.Entities.Flow.XFormDefinition xfDef = null;
            ZumNet.Framework.Entities.Flow.ProcessInstance pi = null;
            ZumNet.Framework.Entities.Flow.XFormInstance xfInst = null;
            ZumNet.Framework.Entities.Flow.WorkItem actWI = null;
            ZumNet.Framework.Entities.Flow.WorkItemList wiList = null;
            DataRow row = null;

            string strReturn = "";
            string sPos = "";
            string sPwdCheck = "F";
            string sCancelButton = "";
            string sPreApprovalWI = "";

            try
            {
                sPos = "100";
                eaDac = new DAL.FlowDac.EApprovalDac();
                procDac = new DAL.FlowDac.ProcessDac();

                //필수항목 체크
                sPos = "200";
                if ((ctrl.ViewBag.JReq["M"].ToString() == "read" || ctrl.ViewBag.JReq["M"].ToString() == "edit" || ctrl.ViewBag.JReq["M"].ToString() == "html") && StringHelper.SafeInt(ctrl.ViewBag.JReq["mi"]) == 0) throw new Exception("필수 항목[MessageID] 누락");
                else if (ctrl.ViewBag.JReq["M"].ToString() == "new")
                {
                    if (ctrl.ViewBag.JReq.ContainsKey("fi") && ctrl.ViewBag.JReq["fi"].ToString() == "")
                    {
                        if (ctrl.ViewBag.JReq.ContainsKey("Tp") && StringHelper.SafeString(ctrl.ViewBag.JReq["Tp"].ToString()) != "" 
                            && ctrl.ViewBag.JReq.ContainsKey("ft") && StringHelper.SafeString(ctrl.ViewBag.JReq["ft"]) != ""
                            && ctrl.ViewBag.JReq.ContainsKey("k1") && StringHelper.SafeString(ctrl.ViewBag.JReq["k1"]) != "")
                        {
                            //외부에서 오는 경우(임시 처리)
                            xfDef = eaDac.GetEAFormData(Convert.ToInt32(HttpContext.Current.Session["DNID"]), "", ctrl.ViewBag.JReq["ft"].ToString());
                            ctrl.ViewBag.JReq["fi"] = xfDef.FormID;
                        }
                        else
                        {
                            throw new Exception("필수 항목[FormID] 누락");
                        }
                    }
                }

                //결재 비밀번호 사용여부
                sPos = "300";
                if (ZumNet.Framework.Configuration.Config.Read("EPwdCheck") == "T" && eaDac.UseEApprovalPassword(Convert.ToInt32(HttpContext.Current.Session["URID"]))) sPwdCheck = "T";

                //msgid와 oid가 맞지 않게 넘어 오는 경우를 위해
                sPos = "400";
                if (ctrl.ViewBag.JReq["xf"].ToString() == "ea" && ctrl.ViewBag.JReq.ContainsKey("mi") && ctrl.ViewBag.JReq["mi"].ToString() != "" && ctrl.ViewBag.JReq["mi"].ToString() != "0")
                {
                    sPos = "410";
                    pi = procDac.SelectProcessInstance(StringHelper.SafeInt(ctrl.ViewBag.JReq["mi"].ToString()), ctrl.ViewBag.JReq["xf"].ToString());
                    if (ctrl.ViewBag.JReq.ContainsKey("oi") && ctrl.ViewBag.JReq["oi"].ToString() != "" && ctrl.ViewBag.JReq["oi"].ToString() != "0")
                    {
                        if (ctrl.ViewBag.JReq["oi"].ToString() != pi.OID.ToString()) throw new Exception("잘못된 프로세스 정보");
                    }
                    ctrl.ViewBag.JReq["oi"] = pi.OID.ToString();

                    sPos = "420";
                    xfInst = eaDac.SelectXFMainEntity(ctrl.ViewBag.JReq["xf"].ToString(), StringHelper.SafeInt(ctrl.ViewBag.JReq["mi"].ToString()));
                    if (xfInst != null)
                    {
                        ctrl.ViewBag.JReq["wn"] = xfInst.PrevWork.ToString();
                        ctrl.ViewBag.JReq["k1"] = xfInst.ExternalKey1;
                        ctrl.ViewBag.JReq["k2"] = xfInst.ExternalKey2;
                    }
                }

                //작업연결 정보
                sPos = "500";
                if (ctrl.ViewBag.JReq.ContainsKey("wn") && ctrl.ViewBag.JReq["wn"].ToString() != "" && ctrl.ViewBag.JReq["wn"].ToString() != "0")
                {
                    row = procDac.SelectWorkItemNotice(StringHelper.SafeLong(ctrl.ViewBag.JReq["wn"].ToString()()));
                    JObject jWn = JObject.Parse("{}");
                    jWn["wnid"] = ctrl.ViewBag.JReq["wn"].ToString();
                    jWn["wnstate"] = row["WnState"].ToString();
                    jWn["appalias"] = row["AppAlias"].ToString();
                    jWn["appid"] = row["AppID"].ToString();
                    jWn["appdn"] = row["AppDN"].ToString();
                    jWn["appmid"] = row["AppMID"].ToString();
                    jWn["preappalias"] = row["PreAppAlias"].ToString();
                    jWn["preappid"] = row["PreAppID"].ToString();
                    jWn["preappdn"] = row["PreAppDN"].ToString();
                    jWn["prepiid"] = row["PrePIID"].ToString();
                    jWn["premid"] = row["PreMID"].ToString();
                    jWn["prewiid"] = row["PreWIID"].ToString();

                    ctrl.ViewBag.WorkNotice = jWn;
                }

                //기안회수 및 선결 버튼
                sPos = "600";
                if (pi != null && pi.State == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.ProcessInstanceState.InProgress)
                {
                    bool bPreApp = false; //선결재 활성화 여부
                    wiList = procDac.SelectWorkItems(pi.OID);
                    if (ctrl.ViewBag.JReq.ContainsKey("wi") && ctrl.ViewBag.JReq["wi"].ToString() != "")
                    {
                        sPos = "610";
                        actWI = procDac.SelectWorkItem(ctrl.ViewBag.JReq["wi"].ToString());
                        //2014-02-18 선결재 활성화 여부 : 현재 결재할 차례가 아니고 현 사용자 수신함에 있지 않은 경우
                        if (HttpContext.Current.Session["FlowPreAppMode"].ToString() == "Y")
                        {
                            bPreApp = true;
                            if (ctrl.ViewBag.JReq["wi"].ToString() == actWI.WorkItemID && actWI.State == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.WorkItemState.InActive
                                && (actWI.ParticipantID == HttpContext.Current.Session["URID"].ToString() || Regex.Split(actWI.ParticipantID, "__")[0] == HttpContext.Current.Session["DeptID"].ToString()))
                            {
                                bPreApp = false;
                            }
                        }
                    }
                    else
                    {
                        sPos = "620";
                        foreach (ZumNet.Framework.Entities.Flow.WorkItem w in wiList.Items)
                        {
                            if (w.ActRole == "_drafter" && w.ParticipantID == HttpContext.Current.Session["URID"].ToString())
                            {
                                actWI = w; ctrl.ViewBag.JReq["wi"] = actWI.WorkItemID; break;
                            }
                        }
                    }

                    if (actWI != null && actWI.ParticipantID == HttpContext.Current.Session["URID"].ToString() && actWI.ActRole == "_drafter")
                    {
                        sPos = "630";
                        sCancelButton = "Y";   //진행중이고 기안자이면 버튼 활성화 가능                                    
                        foreach (ZumNet.Framework.Entities.Flow.WorkItem w in wiList.Items)
                        {
                            if (w.ParentWorkItemID == "" && w.Step > actWI.Step && w.SignKind != (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.SignKind.ByPass
                                && (w.ActRole == "_approver" || w.ActRole == "__r"))
                            {
                                //동서에서는 결재자가 결재하지 않으면 회수 가능
                                if (w.State > 2)
                                {
                                    //처리중, 부서처리중, 완료, 에러 상태가 있으면 회수 불가
                                    sCancelButton = "N"; break;
                                }
                                //if (w.State == (int)Phs.BFF.Entities.ProcessStateChart.WorkItemState.InActive && EApproval.CheckDateTiem(w.ViewDate) == "") { this._cancelButton = "Y"; }
                                //else { this._cancelButton = "N"; break; }
                            }
                        }
                    }

                    //선결재 버튼 관련 : 예고함에 보여지는 경우에 버튼 활성화)
                    if (bPreApp)
                    {
                        sPos = "640";
                        foreach (ZumNet.Framework.Entities.Flow.WorkItem w in wiList.Items)
                        {
                            if (w.ParticipantID == HttpContext.Current.Session["URID"].ToString() && w.State == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.WorkItemState.Penging
                                    && w.ViewState == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.WorkItemViewState.InProgress && w.SignStatus == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.SignStatus.None
                                    && w.SignKind != (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.SignKind.ByPass && w.SignKind != (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.SignKind.Post)
                            {
                                sPreApprovalWI = w.WorkItemID;
                                if (w.SignKind == (int)ZumNet.Framework.Entities.Flow.ProcessStateChart.SignKind.Pre) sPreApprovalWI += "_cancel";
                                break;
                            }
                        }
                    }
                }

                sPos = "700";
                ctrl.ViewBag.PwdCheck = sPwdCheck;
                ctrl.ViewBag.CancelButton = sCancelButton;
                ctrl.ViewBag.PreApprovalWI = sPreApprovalWI;
            }
            catch (Exception ex)
            {
                strReturn = "[" + sPos + "] " + ex.Message;
            }
            finally
            {
                if (eaDac != null) eaDac.Dispose();
                if (procDac != null) procDac.Dispose();
                xfDef = null;
                pi = null;
                xfInst = null;
                actWI = null;
                wiList = null;
            }

            return strReturn;
        }

        /// <summary>
        /// 근무관리 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="ctId"></param>
        /// <returns></returns>
        public static string WorkTimeInit(this Controller ctrl, int ctId)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //메뉴 권한체크 (objecttype='' 이면 폴더권한 체크 X)
            if (HttpContext.Current.Session["Admin"].ToString() == "Y")
            {
                ctrl.ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), ctId, Convert.ToInt32(HttpContext.Current.Session["URID"]), 0, "", "0");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wt = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    svcRt = wt.CheckChiefAcl(Convert.ToInt32(HttpContext.Current.Session["URID"]));
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["chief"] = svcRt.ResultDataString;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                using (ZumNet.BSL.ServiceBiz.WorkTimeBiz wt = new BSL.ServiceBiz.WorkTimeBiz())
                {
                    svcRt = wt.GetMonthStdWorkTime(ctrl.ViewBag.R.current["date"].ToString());
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current.Add("holiday", svcRt.ResultDataDetail["Holiday"].ToString());
                    ctrl.ViewBag.R.current.Add("minhour", svcRt.ResultDataDetail["MinHour"].ToString());
                    ctrl.ViewBag.R.current.Add("maxhour", svcRt.ResultDataDetail["MaxHour"].ToString());
                    ctrl.ViewBag.R.current.Add("extrahour", svcRt.ResultDataDetail["ExtraHour"].ToString());
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            return strReturn;
        }

        /// <summary>
        /// 모델별원가, 개발원가견적 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="ctId"></param>
        /// <param name="ctAlias"></param>
        /// <returns></returns>
        public static string CostInit(this Controller ctrl, int ctId, string ctAlias)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //메뉴 권한체크 (objecttype='' 이면 폴더권한 체크 X)
            if (HttpContext.Current.Session["Admin"].ToString() == "Y")
            {
                ctrl.ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), ctId, Convert.ToInt32(HttpContext.Current.Session["URID"]), 0, "", "0");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            //부서장, 사용 권한
            if (strReturn == "")
            {
                using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                {
                    svcRt = cost.GetMenuAcl(ctId, Convert.ToInt32(HttpContext.Current.Session["URID"]));
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["chief"] = svcRt.ResultDataString.Substring(0, 1);
                    ctrl.ViewBag.R.current["acl"] = svcRt.ResultDataString.Substring(1);
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            //코드정보 설정
            if (ctAlias == "CE")
            {
                string[,] codeConfig = {
                            { "ce", "domestic", "내수 구분" },
                            { "ce", "class", "부문 구분" },
                            { "ce", "buyer", "BUYER 분류" },
                            { "ce", "item", "품목 분류" },
                            { "ce", "center", "생산지 분류" }, 
                            //{ "ce", "distcost", "수출물류비" }, //2020-10-19 삭제
                            { "ce", "xcls", "견적표 작성 구분" }, //2020-10-19 추가
                            { "ce", "costpc", "가공비항목" },
                            { "ce", "costsga", "기타 원가 구성" }
                };

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.SelectCodeDescription(codeConfig);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.CodeConfig = codeConfig;
                    ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }

                #region [기본정보 설정]
                if (strReturn == "")
                {
                    try
                    {
                        using (ZumNet.BSL.InterfaceBiz.CostBiz cost = new BSL.InterfaceBiz.CostBiz())
                        {
                            if (ctrl.ViewBag.R.current["page"].ToString().ToLower() == "grid" && ctrl.ViewBag.R.mode.ToString() != "new"
                                && ctrl.ViewBag.R.mode.ToString() != "add" && StringHelper.SafeInt(ctrl.ViewBag.R.appid.Value) != 0)
                            {
                                svcRt = cost.GetSTDDAY(StringHelper.SafeInt(ctrl.ViewBag.R.appid.Value), "");
                            }
                            else
                            {
                                svcRt = cost.GetSTDDAY(0, "");
                            }
                        }
                        if (svcRt != null && svcRt.ResultCode == 0)
                        {
                            StringBuilder sb = new StringBuilder();
                            sb.Append("{");
                            string[] v = svcRt.ResultDataDetail["XR"] != null ? svcRt.ResultDataDetail["XR"].ToString().Split(';') : "0;".Split(';');
                            sb.AppendFormat("xrate:[{0}, \"{1}\"]", v[0], v[1]);
                            v = svcRt.ResultDataDetail["SP"] != null ? svcRt.ResultDataDetail["SP"].ToString().Split(';') : "0;".Split(';');
                            sb.AppendFormat(",stdpay:[{0}, \"{1}\"]", v[0], v[1]);
                            v = svcRt.ResultDataDetail["OP"] != null ? svcRt.ResultDataDetail["OP"].ToString().Split(';') : "0;".Split(';');
                            sb.AppendFormat(",outpay:[{0}, \"{1}\"]", v[0], v[1]);
                            sb.Append("}");

                            ctrl.ViewBag.R["stdinfo"] = JObject.Parse(sb.ToString());
                            sb.Remove(0, sb.Length);

                            DataTable dt = (DataTable)svcRt.ResultDataDetail["XRATE"];
                            sb.Append("{");
                            int i = 0;
                            foreach (DataColumn col in dt.Columns)
                            {
                                if (col.ColumnName != "REGID" && col.ColumnName != "STDDT" && col.ColumnName != "XCLS")
                                {
                                    if (i > 0) sb.Append(",");
                                    sb.AppendFormat("{0}:\"{1}\"", col.ColumnName, dt.Rows[0][col.ColumnName].ToString());
                                    i++;
                                }
                            }
                            dt = null;
                            i = 0;
                            sb.Append("}");

                            ctrl.ViewBag.R["stdrate"] = JObject.Parse(sb.ToString());
                            sb.Remove(0, sb.Length);

                            sb.Append("{");
                            foreach (object[] o in ctrl.ViewBag.CodeTable["ce.center"])
                            {
                                if (i > 0) sb.Append(",");
                                sb.AppendFormat("{0}:[\"{1}\", {2}]", o[3].ToString(), o[4].ToString(), o[6].ToString());
                                i++;
                            }
                            sb.Append("}");

                            ctrl.ViewBag.R["corp"] = JObject.Parse(sb.ToString());

                            ctrl.ViewBag.R["calcpay"] = JObject.Parse("{}");
                        }
                        else
                        {
                            //에러페이지
                            strReturn = svcRt.ResultMessage;
                        }
                    }
                    catch(Exception ex)
                    {
                        strReturn = ex.Message;
                    }
                }
                #endregion
            }
            else if (ctAlias == "MC")
            {
                string[,] codeConfig = {
                            { "ce", "center", "생산지 분류" },
                            { "mc", "buyer", "BUYER 분류" },
                            { "mc", "item", "품목 분류" }

                };

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.SelectCodeDescription(codeConfig);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.CodeConfig = codeConfig;
                    ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            return strReturn;
        }

        /// <summary>
        /// 대장, 집계 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="ctId"></param>
        /// <param name="fdId"></param>
        /// <returns></returns>
        public static string ReportInit(this Controller ctrl, int ctId, int fdId)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                //권한체크
                if (HttpContext.Current.Session["Admin"].ToString() == "Y")
                {
                    ctrl.ViewBag.R.current["operator"] = "Y";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), ctId, Convert.ToInt32(HttpContext.Current.Session["URID"]), fdId, "O", "0");

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                        ctrl.ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    }
                    else
                    {
                        //에러페이지
                        strReturn = svcRt.ResultMessage;
                    }
                }

                if (strReturn == "")
                {
                    svcRt = cb.SelectCodeDescription("ea", "docstatus", ""); //문서진행상태

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ctrl.ViewBag.DocStatus = svcRt.ResultDataRowCollection;
                    }
                    else
                    {
                        //에러페이지
                        strReturn = svcRt.ResultMessage;
                    }
                }
            }

            //22-02-11 아래코드 RequestInit, AjaxInit으로 옮김
            //if (strReturn == "" && qi != "")
            //{
            //    //JObject jReq = JObject.Parse(HttpContext.Current.Server.UrlDecode(qi));
            //    JObject jReq = JObject.Parse(SecurityHelper.Base64Decode(qi));

            //    ctrl.ViewBag.R.lv.Add("cd1", StringHelper.SafeString(jReq["cd1"]));
            //    ctrl.ViewBag.R.lv.Add("cd2", StringHelper.SafeString(jReq["cd2"]));
            //    ctrl.ViewBag.R.lv.Add("cd3", StringHelper.SafeString(jReq["cd3"]));
            //    ctrl.ViewBag.R.lv.Add("cd4", StringHelper.SafeString(jReq["cd4"]));
            //    ctrl.ViewBag.R.lv.Add("cd5", StringHelper.SafeString(jReq["cd5"]));
            //    ctrl.ViewBag.R.lv.Add("cd6", StringHelper.SafeString(jReq["cd6"]));
            //    ctrl.ViewBag.R.lv.Add("cd7", StringHelper.SafeString(jReq["cd7"]));
            //    ctrl.ViewBag.R.lv.Add("cd8", StringHelper.SafeString(jReq["cd8"]));
            //    ctrl.ViewBag.R.lv.Add("cd9", StringHelper.SafeString(jReq["cd9"]));
            //    ctrl.ViewBag.R.lv.Add("cd10", StringHelper.SafeString(jReq["cd10"]));
            //    ctrl.ViewBag.R.lv.Add("cd11", StringHelper.SafeString(jReq["cd11"]));
            //    ctrl.ViewBag.R.lv.Add("cd12", StringHelper.SafeString(jReq["cd12"]));
            //}

            return strReturn;
        }

        /// <summary>
        /// 교육관리 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string LcmInit(this Controller ctrl)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            ctrl.ViewBag.R["ct"] = StringHelper.SafeString(ctrl.ViewBag.R.ct.ToString(), "118");
            ctrl.ViewBag.R["fdid"] = StringHelper.SafeString(ctrl.ViewBag.R.fdid.ToString(), "0");
            ctrl.ViewBag.R["ft"] = StringHelper.SafeString(ctrl.ViewBag.R.ft.ToString(), "LCM_MAIN"); //기본 페이지 설정

            if (Convert.ToInt32(ctrl.ViewBag.R.fdid.Value) == 0 && ctrl.ViewBag.R["opnode"].ToString() != "")
            {
                if (ctrl.ViewBag.R["opnode"].ToString().IndexOf(".") >= 0)
                {
                    string[] v = ctrl.ViewBag.R["opnode"].ToString().Split('.');
                    ctrl.ViewBag.R["fdid"] = v[v.Length - 1];
                }
                else
                {
                    ctrl.ViewBag.R["fdid"] = ctrl.ViewBag.R["opnode"].ToString();
                }
            }

            //권한체크
            if (HttpContext.Current.Session["Admin"].ToString() == "Y")
            {
                ctrl.ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), Convert.ToInt32(ctrl.ViewBag.R.ct.Value)
                                    , Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(ctrl.ViewBag.R.fdid.Value), "O", "0");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ctrl.ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                //SiteMap
                if (Convert.ToInt32(ctrl.ViewBag.R.fdid.Value) > 0)
                {
                    //Title이 빈값인 경우(Ajax로 불러온 경우 ttl=''로 설정, 이후 로그아웃 되어 returnUrl로 넘어 왔을 때)
                    strReturn = SiteMap(ctrl, Convert.ToInt32(ctrl.ViewBag.R.ct.Value), Convert.ToInt32(ctrl.ViewBag.R.fdid.Value), ctrl.ViewBag.R["opnode"].ToString());
                }
            }

            if (strReturn == "")
            {
                //코드정보 설정
                string[,] codeConfig = {
                        { "lcm", "class_a", "사내외" },
                        { "lcm", "class_b", "교육방식" },
                        { "lcm", "class_c", "교육유형" },
                        { "lcm", "class_d", "교육분야" }

                };

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.SelectCodeDescription(codeConfig);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.CodeConfig = codeConfig;
                    ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                //리스트뷰
                ctrl.ViewBag.R.lv["page"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["page"].ToString(), "1");
                ctrl.ViewBag.R.lv["count"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["count"].ToString(), "50"); //StringHelper.SafeString(Bc.CommonUtils.GetLvCookie("cost").ToString(), "20");
                ctrl.ViewBag.R.lv["cd1"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["cd1"].ToString(), DateTime.Now.Year.ToString()); //기본 교육년도

                //페이지별 초기 설정
                try
                {
                    string formTable = ctrl.ViewBag.R.ft.ToString();
                    if (formTable == "LCM_COURSE") //교육과정관리
                    {
                        ctrl.ViewBag.R["mode"] = StringHelper.SafeString(ctrl.ViewBag.R["mode"].ToString(), "dn");
                        ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["tgt"].ToString(), "0");
                        ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "FromDate");
                    }
                    else if (formTable == "LCM_INSTRUCTOR") //사내교육강사현황
                    {
                        ctrl.ViewBag.R["mode"] = StringHelper.SafeString(ctrl.ViewBag.R["mode"].ToString(), "dn");
                        ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["tgt"].ToString(), "0");
                        ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "ApplDN");
                    }
                    else if (formTable == "LCM_MAIN") //개인신청현황
                    {
                        ctrl.ViewBag.R["mode"] = StringHelper.SafeString(ctrl.ViewBag.R["mode"].ToString(), "PR");
                        ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["tgt"].ToString(), HttpContext.Current.Session["URID"].ToString());
                        ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "CreateDate");
                    }
                    else if (formTable == "LCM_ADMIN") //교육진행현황
                    {
                        ctrl.ViewBag.R["mode"] = StringHelper.SafeString(ctrl.ViewBag.R["mode"].ToString(), "RA");
                        ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["tgt"].ToString(), HttpContext.Current.Session["URID"].ToString());
                        ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "CreateDate");
                    }
                    else if (formTable == "LCM_EDUPOINT") //결과집계현황 
                    {
                        ctrl.ViewBag.R["mode"] = StringHelper.SafeString(ctrl.ViewBag.R["mode"].ToString(), "RA");
                        ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["tgt"].ToString(), HttpContext.Current.Session["URID"].ToString());
                        ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "");
                    }
                }
                catch (Exception ex)
                {
                    strReturn = ex.Message;
                }
            }

            return strReturn;
        }

        /// <summary>
        /// VOC 코드 정보
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string LcmCode(this Controller ctrl)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //코드정보 설정
            string[,] codeConfig = {
                        { "lcm", "class_a", "사내외" },
                        { "lcm", "class_b", "교육방식" },
                        { "lcm", "class_c", "교육유형" },
                        { "lcm", "class_d", "교육분야" }

            };

            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                svcRt = cb.SelectCodeDescription(codeConfig);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ctrl.ViewBag.CodeConfig = codeConfig;
                ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
            }
            else
            {
                //에러페이지
                strReturn = svcRt.ResultMessage;
            }

            return strReturn;
        }

        /// <summary>
        /// 업무일지 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="menuInfo"></param>
        /// <returns></returns>
        public static string ToDoInit(this Controller ctrl, bool menuInfo)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            ctrl.ViewBag.R["ct"] = StringHelper.SafeString(ctrl.ViewBag.R.ct.ToString(), "111"); //ctalias=schedule 크레신에서 업무일정을 일지로 사용
            //ctrl.ViewBag.R["fdid"] = StringHelper.SafeInt(ctrl.ViewBag.R.fdid, Convert.ToInt32(HttpContext.Current.Session["URID"])); //조회 대상
            ctrl.ViewBag.R["fdid"] = StringHelper.SafeInt(ctrl.ViewBag.R.fdid) == 0 ? HttpContext.Current.Session["URID"].ToString() : ctrl.ViewBag.R.fdid.ToString(); //조회 대상
            ctrl.ViewBag.R["ot"] = StringHelper.SafeString(ctrl.ViewBag.R.ot.ToString(), "UR"); //대상 구분
            ctrl.ViewBag.R["xfalias"] = StringHelper.SafeString(ctrl.ViewBag.R.xfalias.ToString(), "schedule");
            ctrl.ViewBag.R["opnode"] = StringHelper.SafeString(ctrl.ViewBag.R.opnode.ToString(), "UR." + HttpContext.Current.Session["URID"].ToString()); //메뉴 위치 구별
            ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv.tgt.ToString(), DateTime.Now.ToString("yyyy-MM-dd")); //조회 희망 일자

            //권한체크
            if (HttpContext.Current.Session["Admin"].ToString() == "Y")
            {
                ctrl.ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), Convert.ToInt32(ctrl.ViewBag.R.ct.Value)
                                    , Convert.ToInt32(HttpContext.Current.Session["URID"]), 0, "O", "0");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            //관리자 권한
            //if (ctrl.ViewBag.R.current["operator"].ToString() == "Y")
            //{ 
            //    ctrl.ViewBag.R.current["acl"] = "SFDERVSDEMWRV";
            //    ctrl.ViewBag.R.current["appacl"] = "A"; 
            //}

            //현 사용자 권한
            if (ctrl.ViewBag.R["ot"].ToString() == "UR" && ctrl.ViewBag.R["fdid"].ToString() == HttpContext.Current.Session["URID"].ToString())
            {
                ctrl.ViewBag.R.current["acl"] = "SFDERVSDEMWRV";
                ctrl.ViewBag.R.current["appacl"] = "A";
            }

            if (strReturn == "" && menuInfo)
            {
                //메뉴 부서원 목록 설정
                using (ZumNet.BSL.ServiceBiz.ToDoBiz todo = new BSL.ServiceBiz.ToDoBiz())
                {
                    svcRt = todo.GetToDoMenuList(Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(HttpContext.Current.Session["DeptID"]));
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.MenuInfo = svcRt.ResultDataDetail;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                DateTime dtTraget = Convert.ToDateTime(ctrl.ViewBag.R.lv["tgt"]);
                for(int i = 0; i < 7; i++)
                {
                    if (dtTraget.AddDays(-i).DayOfWeek == System.DayOfWeek.Monday)
                    {
                        ctrl.ViewBag.Monday = dtTraget.AddDays(-i); //해당 주의 첫 월요일 날짜 반환
                    }
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("{");
                //상태 : 표기, 아이콘, 색상
                sb.Append("s_0:[\"시작전\",\"far fa-check-square fs-16\",\"text-light\"],");
                sb.Append("s_1:[\"진행중\",\"fas fa-check-square fs-16\",\"text-warning\"],");
                sb.Append("s_4:[\"지연\",\"fas fa-check-square fs-16\",\"text-danger\"],");
                sb.Append("s_7:[\"완료\",\"fas fa-check-square fs-16\",\"text-success\"],");
                
                sb.Append("cs_0:[\"미확인\",\"far fa-check-square fs-16\",\"text-light\"],");
                sb.Append("cs_1:[\"확인\",\"fas fa-check-square fs-16\",\"\"],");
                sb.Append("cs_4:[\"보류\",\"fas fa-exclamation-triangle fs-16\",\"text-secondary\"],");
                sb.Append("cs_7:[\"완료\",\"fas fa-check-square fs-16\",\"text-success\"]");
                sb.Append("}");
                ctrl.ViewBag.State = JObject.Parse(sb.ToString());
            }

            return strReturn;
        }

        /// <summary>
        /// 업무일지 초기 설정 중 일부 가져올 때
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string ToDoInit(this Controller ctrl)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("{");
            //상태 : 표기, 아이콘, 색상
            sb.Append("s_0:[\"시작전\",\"far fa-check-square fs-16\",\"text-light\"],");
            sb.Append("s_1:[\"진행중\",\"fas fa-check-square fs-16\",\"text-warning\"],");
            sb.Append("s_4:[\"지연\",\"fas fa-check-square fs-16\",\"text-danger\"],");
            sb.Append("s_7:[\"완료\",\"fas fa-check-square fs-16\",\"text-success\"],");

            sb.Append("cs_0:[\"미확인\",\"far fa-check-square fs-16\",\"text-light\"],");
            sb.Append("cs_1:[\"확인\",\"fas fa-check-square fs-16\",\"\"],");
            sb.Append("cs_4:[\"보류\",\"fas fa-exclamation-triangle fs-16\",\"text-secondary\"],");
            sb.Append("cs_7:[\"완료\",\"fas fa-check-square fs-16\",\"text-success\"]");
            sb.Append("}");
            ctrl.ViewBag.State = JObject.Parse(sb.ToString());

            return "";
        }

        /// <summary>
        /// 자원에약 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="resView"></param>
        /// <returns></returns>
        public static string BookingInit(this Controller ctrl, bool resView)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            ctrl.ViewBag.R["xfalias"] = StringHelper.SafeString(ctrl.ViewBag.R.xfalias.ToString(), "schedule");
            ctrl.ViewBag.R["fdid"] = StringHelper.SafeString(ctrl.ViewBag.R.fdid.ToString(), "0");
            if (resView)
            {
                ctrl.ViewBag.R["ot"] = StringHelper.SafeString(ctrl.ViewBag.R.ot.ToString(), "FD"); //대상 구분
                //ctrl.ViewBag.R["opnode"] = StringHelper.SafeString(ctrl.ViewBag.R.opnode.ToString(), "FD." + ctrl.ViewBag.R.fdid.ToString()); //메뉴 위치 구별
                ctrl.ViewBag.R.lv["tgt"] = StringHelper.SafeString(ctrl.ViewBag.R.lv.tgt.ToString(), DateTime.Now.ToString("yyyy-MM-dd")); //조회 희망 일자
            }
            else
            {
                //ctrl.ViewBag.R["ct"] = StringHelper.SafeString(ctrl.ViewBag.R.ct.ToString(), "112");
                //ctrl.ViewBag.R["fdid"] = StringHelper.SafeString(ctrl.ViewBag.R.fdid.ToString(), "0");
            }

            int iCategoryId = Convert.ToInt32(ctrl.ViewBag.R.ct.Value);
            int iFolderId = Convert.ToInt32(ctrl.ViewBag.R.fdid.Value);

            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                //권한체크
                if (HttpContext.Current.Session["Admin"].ToString() == "Y")
                {
                    ctrl.ViewBag.R.current["operator"] = "Y";
                    ctrl.ViewBag.R.current["acl"] = "SFDERVSDEMWRV";
                }
                else
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), iCategoryId, Convert.ToInt32(HttpContext.Current.Session["URID"]), iFolderId, "B", "0");

                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                        if (iFolderId > 0) ctrl.ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                    }
                    else
                    {
                        //에러페이지
                        strReturn = svcRt.ResultMessage;
                    }
                }

                if (iFolderId > 0 && ctrl.ViewBag.R.current["appacl"].ToString() == "")
                    ctrl.ViewBag.R.current["appacl"] = ctrl.ViewBag.R.current["acl"].ToString().Substring(6, 4) + ctrl.ViewBag.R.current["acl"].ToString().Substring(ctrl.ViewBag.R.current["acl"].ToString().Length - 2);
            }

            if (resView)
            {
                using (ZumNet.BSL.ServiceBiz.ScheduleBiz schBiz = new BSL.ServiceBiz.ScheduleBiz())
                {
                    svcRt = schBiz.GetResourceInfomation(Convert.ToInt32(HttpContext.Current.Session["DNID"]), iFolderId, ctrl.ViewBag.R["ot"].ToString());
                    if (svcRt != null && svcRt.ResultCode == 0 && svcRt.ResultDataRow != null)
                    {
                        ctrl.ViewBag.ResInfo = svcRt.ResultDataRow;
                        ctrl.ViewBag.R["ttl"] = svcRt.ResultDataRow["Parent"].ToString() + " / " + svcRt.ResultDataRow["DisplayName"].ToString();
                    }
                    else
                    {
                        //strReturn = svcRt.ResultItemCount == 0 ? "자원 정보 누락" : svcRt.ResultMessage;
                    }

                    if (strReturn == "")
                    {
                        svcRt = schBiz.GetScheduleMenuType(iCategoryId);
                        if (svcRt != null && svcRt.ResultCode == 0 && svcRt.ResultItemCount > 0)
                        {
                            ctrl.ViewBag.SchType = svcRt.ResultDataRowCollection;
                        }
                        else
                        {
                            strReturn = svcRt.ResultItemCount == 0 ? "일정 종류 누락" : svcRt.ResultMessage;
                        }
                    }
                }
            }

            return strReturn;
        }

        /// <summary>
        /// VOC 초기 설정
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="codeInfo"></param>
        /// <returns></returns>
        public static string VocInit(this Controller ctrl, bool codeInfo)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //권한체크
            if (HttpContext.Current.Session["Admin"].ToString() == "Y")
            {
                ctrl.ViewBag.R.current["operator"] = "Y";
            }
            else
            {
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.GetObjectPermission(Convert.ToInt32(HttpContext.Current.Session["DNID"]), Convert.ToInt32(ctrl.ViewBag.R.ct.Value)
                                    , Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(ctrl.ViewBag.R.fdid.Value), "O", "0");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.R.current["operator"] = svcRt.ResultDataDetail["operator"].ToString();
                    ctrl.ViewBag.R.current["acl"] = svcRt.ResultDataDetail["acl"].ToString();
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            if (strReturn == "")
            {
                //SiteMap
                if (Convert.ToInt32(ctrl.ViewBag.R.fdid.Value) > 0)
                {
                    //Title이 빈값인 경우(Ajax로 불러온 경우 ttl=''로 설정, 이후 로그아웃 되어 returnUrl로 넘어 왔을 때)
                    strReturn = SiteMap(ctrl, Convert.ToInt32(ctrl.ViewBag.R.ct.Value), Convert.ToInt32(ctrl.ViewBag.R.fdid.Value), ctrl.ViewBag.R["opnode"].ToString());
                }

                //리스트뷰
                ctrl.ViewBag.R.lv["page"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["page"].ToString(), "1");
                ctrl.ViewBag.R.lv["count"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["count"].ToString(), "50");

                ctrl.ViewBag.R.lv["basesort"] = StringHelper.SafeString(ctrl.ViewBag.R.lv["basesort"].ToString(), "RCTDT");
            }

            if (strReturn == "" && codeInfo)
            {
                //코드정보 설정
                string[,] codeConfig = {
                        { "voc", "reason", "고장유형" },
                        { "voc", "request", "구분" },
                        { "voc", "prodcls", "제품분류" },
                        { "voc", "kind", "VOC" },
                        { "voc", "result", "최종판정" },
                        { "voc", "status", "진행상태" },
                        { "voc", "repair", "수리내역" },
                        { "voc", "trouble", "불량유형" }
                };

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = cb.SelectCodeDescription(codeConfig);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    ctrl.ViewBag.CodeConfig = codeConfig;
                    ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
                }
                else
                {
                    //에러페이지
                    strReturn = svcRt.ResultMessage;
                }
            }

            return strReturn;
        }

        /// <summary>
        /// VOC 코드 정보
        /// </summary>
        /// <param name="ctrl"></param>
        /// <returns></returns>
        public static string VocInit(this Controller ctrl)
        {
            string strReturn = "";
            ZumNet.Framework.Core.ServiceResult svcRt = null;

            //코드정보 설정
            string[,] codeConfig = {
                        { "voc", "request", "" },
                        { "voc", "kind", "" },
                        { "voc", "result", "" },
                        { "voc", "status", "" },
                        { "voc", "repair", "" },
                        { "voc", "trouble", "" },
                        { "voc", "prodmodel", "" },
                        { "voc", "prodcolor", "" },
                        { "voc", "reason", "" }
                };

            using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
            {
                svcRt = cb.SelectCodeDescription(codeConfig);
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                ctrl.ViewBag.CodeConfig = codeConfig;
                ctrl.ViewBag.CodeTable = svcRt.ResultDataDetail;
            }
            else
            {
                //에러페이지
                strReturn = svcRt.ResultMessage;
            }

            return strReturn;
        }
        #endregion
    }  
    #endregion
}