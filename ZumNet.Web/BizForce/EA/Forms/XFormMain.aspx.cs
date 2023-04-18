using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ZumNet.Framework.Util;

namespace ZumNet.Web.BizForce.EA.Forms
{
    public partial class XFormMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string mode = StringHelper.SafeString(Request["M"], "");
            string formId = StringHelper.SafeString(Request["fi"], "");

            if (mode == "" && formId != "") mode = "new";
            else mode = "read";

            JObject j = JObject.Parse("{}");
            j["M"] = mode;
            j["xf"] = StringHelper.SafeString(Request["xf"], "ea");
            j["fi"] = formId;

            j["mi"] = StringHelper.SafeString(Request["mi"], "0");
            j["oi"] = StringHelper.SafeString(Request["oi"], "0");
            j["wi"] = StringHelper.SafeString(Request["wi"], "");

            //if (mode == "new" && formId != "")
            //{
                
            //}
            //else
            //{
            //    j["mi"] = StringHelper.SafeString(Request["mi"], "0");
            //    j["oi"] = StringHelper.SafeString(Request["oi"], "0");
            //    j["wi"] = StringHelper.SafeString(Request["wi"], "");
            //}

            //Response.Write(JsonConvert.SerializeObject(j));

            string url = "/EA/Form?qi=" + SecurityHelper.ToBase64(JsonConvert.SerializeObject(j));
            Response.Redirect(url, true);
        }
    }
}