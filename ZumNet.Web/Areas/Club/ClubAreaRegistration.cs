using System;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.Club
{
    public class ClubAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Club";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            //context.MapRoute(
            //    "Club_list",
            //    "Club/{controller}/{action}/{qi}",
            //    new { action = "Index", qi = UrlParameter.Optional }
            //);

            context.MapRoute(
                "Club_default",
                "Club/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional },
                new String[] { "ZumNet.Web.Areas.Club.Controllers" }
            );
        }
    }
}