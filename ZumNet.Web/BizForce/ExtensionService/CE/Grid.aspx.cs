using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

namespace ZumNet.Web.BizForce.ExtensionService.CE
{
    public partial class Grid : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //return "?qi=" + Server.UrlEncode(ZumNet.Framework.Util.SecurityHelper.ToBase64("{M:\"" + m + "\",ct:\"" + ViewBag.R.ct + "\",ctalias:\"" + ViewBag.R.ctalias + "\",ttl:\"\",opnode:\"\",ft:\"Grid\",appid:\"" + appId + "\"}"));
            string mode = StringHelper.SafeString(Request["M"], "");
            string ceId = StringHelper.SafeString(Request["app"], "");

            JObject j = JObject.Parse("{}");
            j["M"] = mode;
            j["ct"] = "304";
            j["ctalias"] = "CE";

            j["ttl"] = "";
            j["opnode"] = "";
            j["ft"] = "Grid";
            j["appid"] = ceId;

            string url = "/ExS//CE/Grid?qi=" + SecurityHelper.ToBase64(JsonConvert.SerializeObject(j));
            Response.Redirect(url, true);
        }
    }
}