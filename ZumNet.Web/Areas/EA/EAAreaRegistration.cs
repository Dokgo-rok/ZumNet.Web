using System;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.EA
{
    public class EAAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "EA";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            //context.MapRoute(
            //    "EA_list",
            //    "EA/{controller}/{action}/{qi}",
            //    new { action = "Index", qi = UrlParameter.Optional }
            //);

            context.MapRoute(
                "EA_default",
                "EA/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional },
                new String[] { "ZumNet.Web.Areas.EA.Controllers" }
            );
        }
    }
}