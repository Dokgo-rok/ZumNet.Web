using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZumNet.Web.BizForce.PortalService.Person
{
    public partial class PersonSimpleInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ZumNet.Framework.Core.ServiceResult svcRt = null;
            using (ZumNet.BSL.ServiceBiz.OfficePortalBiz op = new ZumNet.BSL.ServiceBiz.OfficePortalBiz())
            {
                svcRt = op.GetUserPersonalInfo(Convert.ToInt32(Request["userid"].ToString()));
            }

            if (svcRt != null && svcRt.ResultCode == 0)
            {
                
            }
            else
            {
                //에러페이지
                
            }
        }

        private string GetOrgUserImageEx(string logonId)
        {
            string imagepath = Server.MapPath("~/Storage/cresyn/PersonPhoto/" + logonId + ".jpg");
            string imageFormat = "image/jpg";
            string imageOpacity = "";

            if (!File.Exists(imagepath))
            {
                imagepath = Server.MapPath("~/images/plugins/user.png");
                imageFormat = "image/png";
                imageOpacity = " opacity-50";
            }
            FileStream fs = new FileStream(imagepath, FileMode.Open);
            byte[] byData = new byte[fs.Length];
            fs.Read(byData, 0, byData.Length);
            fs.Close();

            var base64 = Convert.ToBase64String(byData);

            return String.Format("<img src=\"data:{0};base64,{1}\" alt=\"User Image\" class=\"mb-2 contact-content-img{2}\">", imageFormat, base64, imageOpacity);
        }

        private string GetOrgUserImage(string logonId)
        {
            string imagepath = "/Storage/cresyn/PersonPhoto/" + logonId + ".jpg";
            string imageOpacity = "";

            if (!File.Exists(Server.MapPath(imagepath)))
            {
                imagepath = "/images/plugins/user.png";
                imageOpacity = " opacity-50";
            }

            //return String.Format("<img src=\"{0}\" alt=\"User Image\" class=\"contact-content-img{1}\" onerror=\"this.src='/images/plugins/user.png'\">", imagepath, imageOpacity);
            return String.Format("<img src=\"{0}\" alt=\"User Image\" class=\"contact-content-img{1}\">", imagepath, imageOpacity);
        }
    }
}