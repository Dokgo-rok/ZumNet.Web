using System.Web.Mvc;

namespace ZumNet.Web.Areas.ExS
{
    public class ExSAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "ExS";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            //context.MapRoute(
            //    "ExS_list",
            //    "ExS/{controller}/{action}/{qi}",
            //    new { action = "Index", qi = UrlParameter.Optional }
            //);

            context.MapRoute(
                "ExS_default",
                "ExS/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}