using System;
using System.Configuration;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ZumNet.Framework.Util;

namespace DocSecurity
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string strTargetPath = ""; //암복호화 후 파일경로
            string strReturn = "파일 경로 누락!";
            string strRealPath = StringHelper.SafeString(Request["rp"], "");
            if (strRealPath == "")
            {
                Response.Write(strReturn);
                Response.End();
            }
            //strRealPath = HttpContext.Current.Server.MapPath(strRealPath); --> 절대경로로 넘어온다

            strReturn = "암호화 구분 누락!";
            string strConvertType = StringHelper.SafeString(Request["cvt"], ""); //enc, dec
            if (strConvertType == "")
            {
                Response.Write(strReturn);
                Response.End();
            }

            DocSecurity.App_Code.SoftcampDS scDS = new DocSecurity.App_Code.SoftcampDS();

            if (strConvertType == "dec")
            {
                //파일 업로드일 경우 복호화
                strReturn = scDS.DecFile(strRealPath);
                if (strReturn == "OK" || strReturn.Substring(0, 2) == "NS" || strReturn.Substring(0, 2) == "NE") Response.Write("OK" + strTargetPath);
                else Response.Write(strReturn);
            }
            else if (strConvertType == "enc")
            {
                //파일 다운로드일 경우 암호화
                strReturn = "확장자 누락!";
                string strExt = StringHelper.SafeString(Request["ext"], "");
                if (strExt == "")
                {
                    Response.Write(strReturn);
                    Response.End();
                }

                strReturn = "다운로드 경로 누락!";
                string strDownFolder = StringHelper.SafeString(Request["df"], ""); //UploadPath + useraccount
                if (strDownFolder == "")
                {
                    Response.Write(strReturn);
                    Response.End();
                }
                strDownFolder = HttpContext.Current.Server.MapPath(strDownFolder + "/DocSecurity/");
                strReturn = scDS.EncFile(strRealPath, strDownFolder, strExt);
                if (strReturn == "OK" || strReturn.Substring(0, 2) == "NS") Response.Write("OK" + strReturn.Substring(2));
                else Response.Write(strReturn);
            }

            scDS = null;

            Response.End();



            //string strFile = "test.mht";
            //string strFile = "K_외부사양서-서비스링커4.0_JAVA.doc";
            //string strPath = @"D:\";

            //string strDest2 = "";
            //string strReturn = "";

            //FileInfo fi = new FileInfo(strPath + strFile);
            //strDest = strPath + fi.Name.Replace(fi.Extension, "") + "_enc" + fi.Extension;
            //strDest2 = strPath + fi.Name.Replace(fi.Extension, "") + "_dec" + fi.Extension;

            //Response.Write("DIR => " + fi.DirectoryName + "<br />");
            //Response.Write("DEST => " + strDest + "<br />");
            //Response.Write("DEST2 => " + strDest2 + "<br />");
            //fi = null;
            //Response.End();

            //SoftcampDS scDS = new SoftcampDS();

            //strReturn = scDS.EncFile(strPath + strFile, strDest);


            //strReturn = scDS.DecFile(strPath + strFile, strDest2);

            //scDS = null;

            //Response.Write(strReturn);
        }
    }
}