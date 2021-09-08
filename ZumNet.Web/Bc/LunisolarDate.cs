using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace ZumNet.Web.Bc
{
	/// <summary>
	/// 음력 <-> 양력 변환 클래스
	/// </summary>
	public class LunisolarDate
    {
		private static KoreanLunisolarCalendar _calendar = new KoreanLunisolarCalendar();

		private static string[] _cheongan = new string[10] { "갑", "을", "병", "정", "무", "기", "경", "신", "임", "계" };

		private static string[] _jiji = new string[12] { "자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해" };

		private static string[] _tti = new string[12] { "쥐", "소", "범", "토끼", "용", "뱀", "말", "양", "원숭이", "닭", "개", "돼지" };

		private int _year;              // 음력 년
		private int _month;             // 음력 월
		private int _day;               // 음력 일
		private bool _isLeapMonth;      // 윤달 여부

		private DateTime _solarDate;    // 양력 년월일

		#region Properties

		/// <summary>양력 년월일</summary>
		public DateTime SolarDate { get { return _solarDate; } }

		/// <summary>음력 년월일</summary>
		public DateTime LunaDate { get { return new DateTime(Year, Month, Day); } }

		/// <summary>음력 년</summary>
		public int Year { get { return _year; } }

		/// <summary>음력 월</summary>
		public int Month { get { return _month; } }

		/// <summary>음력 일</summary>
		public int Day { get { return _day; } }

		/// <summary>윤달</summary>
		public bool LeapMonth { get { return _isLeapMonth; } }

		/// <summary>육십갑자(육갑)</summary>
		public string SexagenaryCycle
		{
			get
			{
				int sexagenaryYear = _calendar.GetSexagenaryYear(_solarDate);
				int c = _calendar.GetCelestialStem(sexagenaryYear) - 1;
				int j = _calendar.GetTerrestrialBranch(sexagenaryYear) - 1;

				return string.Format("{0}{1}", _cheongan[c], _jiji[j]);
			}
		}

		/// <summary>띠</summary> 
		public string Terrestrial
		{
			get
			{
				int sexagenaryYear = _calendar.GetSexagenaryYear(_solarDate);
				int j = _calendar.GetTerrestrialBranch(sexagenaryYear) - 1;

				return _tti[j];
			}
		}

		#endregion

		private LunisolarDate()
		{
		}

		/// <summary>
		/// 음력 날짜 클래스 기본 생성자.
		/// </summary>
		/// <param name="year">음력 년</param>
		/// <param name="month">음력 월</param>
		/// <param name="day">음력 일</param>
		public LunisolarDate(int year, int month, int day) : this(year, month, day, false)
		{
		}

		/// <summary>
		/// 음력 날짜 클래스 생성자.
		/// </summary>
		/// <param name="year">음력 년</param>
		/// <param name="month">음력 월</param>
		/// <param name="day">음력 일</param>
		/// <param name="leap">윤달 여부</param>
		public LunisolarDate(int year, int month, int day, bool isLeapMonth)
		{
			_year = year;
			_month = month;
			_day = day;

			// 간지 및 띠 계산은 양력날짜를 기준으므로 하므로
			// 입력한 음력날짜를 양력날짜로 변환하여 저장함.
			if (_calendar.GetMonthsInYear(year) > 12)
			{
				int leapMonth = _calendar.GetLeapMonth(year);

				if (month >= leapMonth - 1)
				{
					_isLeapMonth = ((month + 1) == leapMonth && isLeapMonth);
					_solarDate = _calendar.ToDateTime(year, month + 1, day, 0, 0, 0, 0);
				}
				else
				{
					_solarDate = _calendar.ToDateTime(year, month, day, 0, 0, 0, 0);
				}
			}
			else
			{
				// 육십갑자 계산을 양력을 기준으로 하기 때문에 전달받은 음력 날짜를
				// 양력으로 변환하여 저장함.
				_solarDate = _calendar.ToDateTime(year, month, day, 0, 0, 0, 0);
			}
		}

		public static LunisolarDate ConvertFromSolarDate(DateTime solarDate)
		{
			LunisolarDate date = new LunisolarDate();

			date._solarDate = solarDate;                    // 양력 년월일
			date._year = _calendar.GetYear(solarDate);      // 음력 년
			date._month = _calendar.GetMonth(solarDate);    // 음력 월
			date._day = _calendar.GetDayOfMonth(solarDate); // 음력 일

			// 윤달이 끼어 있으면..
			if (_calendar.GetMonthsInYear(date._year) > 12)
			{
				int leapMonth = _calendar.GetLeapMonth(date.Year);

				// 윤달보다 크거나 같으면 달수가 1씩 더해지므로 이를 재조정 함.
				if (date.Month >= leapMonth)
				{
					date._isLeapMonth = (date.Month == leapMonth);
					date._month--;
				}
			}

			return date;
		}

		/// <summary>
		/// 전달한 음력 년월의 윤달여부를 확인합니다.
		/// </summary>
		/// <param name="lunisolarDate">음력 날짜</param>
		/// <returns>윤달이면 True를 반환</returns>
		public static bool IsLeapMonth(DateTime lunisolarDate)
		{
			return IsLeapMonth(lunisolarDate.Year, lunisolarDate.Month);
		}

		/// <summary>
		/// 전달한 음력 년월의 윤달여부를 확인합니다.
		/// </summary>
		/// <param name="lunisolarYear">음력 년</param>
		/// <param name="lunisolarMonth">음력 월</param>
		/// <returns>윤달이면 True를 반환</returns>
		public static bool IsLeapMonth(int lunisolarYear, int lunisolarMonth)
		{
			return _calendar.IsLeapMonth(lunisolarYear, lunisolarMonth);
		}
	}
}