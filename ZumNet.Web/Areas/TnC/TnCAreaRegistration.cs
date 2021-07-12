using System;
using System.Web.Mvc;

namespace ZumNet.Web.Areas.TnC
{
    public class TnCAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "TnC";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            //context.MapRoute(
            //    "TnC_list",
            //    "TnC/{controller}/{action}/{qi}",
            //    new { action = "Index", qi = UrlParameter.Optional }
            //);

            context.MapRoute(
                "TnC_default",
                "TnC/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional },
                new String[] { "ZumNet.Web.Areas.TnC.Controllers" }
            );
        }
    }
}