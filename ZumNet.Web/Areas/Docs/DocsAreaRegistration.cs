using System.Web.Mvc;

namespace ZumNet.Web.Areas.Docs
{
    public class DocsAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Docs";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            //context.MapRoute(
            //    "Docs_list",
            //    "Docs/{controller}/{action}/{qi}",
            //    new { action = "Index", qi = UrlParameter.Optional }
            //);

            context.MapRoute(
                "Docs_default",
                "Docs/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}