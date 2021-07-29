using System.Web;
using System.Web.Mvc;

using ZumNet.Web.Filter;

namespace ZumNet.Web
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new CultureFilter());
            filters.Add(new HandleErrorAttribute());
        }
    }
}
