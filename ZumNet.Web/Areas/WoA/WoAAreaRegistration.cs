using System.Web.Mvc;

namespace ZumNet.Web.Areas.WoA
{
    public class WoAAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "WoA";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "WoA_default",
                "WoA/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}