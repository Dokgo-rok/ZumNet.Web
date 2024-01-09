using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ZumNet.Framework.Util;

namespace ZumNet.Web.BizForce.PortalService
{
    public partial class FileDown : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int _attachId = 0;
            bool _disableDocSecurity = false; //기본 보안설정

            string sUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
            string sRealPath = Request["fp"] != null ? Request["fp"].ToString() : "";
            string sFileName = Request["fn"] != null ? Request["fn"].ToString() : "";

            try
            {
                sRealPath = SecurityHelper.Base64Decode(sRealPath).Replace(@"\", "/");
                sFileName = SecurityHelper.Base64Decode(sFileName);
            }
            catch
            {
                sRealPath = Server.UrlDecode(sRealPath);
                sFileName = Server.UrlDecode(sFileName);
            }

            string sXFAlias = StringHelper.SafeString(Request["xf"]);
            string sSavedName = StringHelper.SafeString(Request["sn"]);

            //Response.Write(Request["fp"].ToString() + " : " + Request["fn"].ToString());
            //Response.Write(Request["fp"].ToString() + " : " + SecurityHelper.Base64Decode(Request["fp"].ToString()) + "<br />");
            //Response.Write(Request["fn"].ToString() + " : " + SecurityHelper.Base64Decode(Request["fn"].ToString()) + "<br />");

            if (sXFAlias != "" && sSavedName != "")
            {
                DataSet ds = null;
                using (ZumNet.DAL.FlowDac.EApprovalDac eaDac = new ZumNet.DAL.FlowDac.EApprovalDac())
                {
                    ds = eaDac.GetAttachedFileInfo(sXFAlias, sSavedName);
                }

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    sFileName = dr["FileName"].ToString();
                    sRealPath = dr["FilePath"].ToString();

                    //Response.Write("real => " + sRealPath); Response.End();

                    int iPos = sRealPath.IndexOf(@"\");
                    sRealPath = sRealPath.Substring(iPos);

                    //2020-02-04 문서보안해제신청서 양식 첨부파일 결재 완료 후 7일 이내 보안해제
                    _attachId = Convert.ToInt32(dr["AttachID"]);
                    if (dr["DisableSecurity"].ToString() == "Y")
                    {
                        _disableDocSecurity = true;
                    }

                    sRealPath = Server.MapPath(sRealPath.Replace("\\", "/")); //2024-01-09
                }
            }
            else
            {
                sRealPath = Server.MapPath(sRealPath);
            }

            //2014-06-19 크레신, pdf는 DRM 적용이 돼 있을 수 있으므로 제외
            string[] vFile = sFileName.Split('.');
            string ext = vFile[vFile.Length - 1];

            //2019-05-31 첨부경로 확인
            if (!System.IO.File.Exists(sRealPath))
            {
                //throw new Exception("해당 파일을 찾을 수 없습니다!"); //2024-01-03
                //Response.Write("해당 파일(" + sRealPath + ")을 찾을 수 없습니다!");
                //Response.End();

                //sRealPath = sRealPath.ToLower().Replace(@"\storage\", @"\Archive\");
                //Response.Write("여기 => " + sNewPath + " : " + File.Exists(Server.MapPath(sNewPath)).ToString());
                //DownloadWithDotNet(strRealPath, strFileName, ext);
            }

            //2020-10-27 스토리지 2차 추가로 인한 경로 추가확인
            //if (!System.IO.File.Exists(sRealPath))
            //{
            //    sRealPath = sRealPath.ToLower().Replace(@"\archive\", @"\ArchiveD\");
            //}

            //2020-02-04 첨부파일 클릭 로깅
            try
            {
                using (ZumNet.DAL.FlowDac.EApprovalDac eaDac = new ZumNet.DAL.FlowDac.EApprovalDac())
                {
                    eaDac.InsertEventFileView(_attachId, sFileName, sSavedName, sRealPath, Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString()
                                , Session["URName"].ToString(), Request.ServerVariables["REMOTE_HOST"], sUserAgent, (_disableDocSecurity ? "Y" : "N"));
                }
            }
            catch (Exception ex)
            {
                //오류 처리 X
                //Response.Write(ex);
                //Response.End();
            }

            //_disableDocSecurity = true;

            if (ext == "tif" || ext == "tiff" || ext == "jpg" || ext == "jpeg" || ext == "bmp"
                 || ext == "gif" || ext == "png" || ext == "mht" || ext == "mhtml" || ext == "htm" || ext == "html")
            {
                //보안 정책 예외 확장자 2015-01-09
            }
            else
            {
                if (!_disableDocSecurity)
                {
                    //2014-11-12 파일 암호화
                    sRealPath = EncrypFile(sRealPath, ext);
                }
            }

            if (ext == "__pdf" || ext == "tif" || ext == "tiff" || ext == "jpg" || ext == "jpeg"
                 || ext == "bmp" || ext == "gif" || ext == "png" || ext == "mht" || ext == "mhtml")
            {
                DownloadWithDotNet(sUserAgent, sRealPath, sFileName, ext);
            }
            else
            {
                //DownloadWithDextUpload(sRealPath, sFileName);
                DownloadWithDotNet(sUserAgent, sRealPath, sFileName, ext);
            }
        }

        //.Net을 이용한 내려받기
        private void DownloadWithDotNet(string userAgent, string realPath, string fileName, string ext)
        {
            string strContentType = "";
            string strContentDispos = "";

            fileName = fileName.Replace(",", "_"); //22-07-14 "," 오류로 인해 임시로 처리

            if (ext == "pdf" || ext == "tif" || ext == "tiff" || ext == "jpg" || ext == "jpeg"
                 || ext == "bmp" || ext == "gif" || ext == "png" || ext == "mht" || ext == "mhtml")
            {
                if (ext == "pdf") strContentType = "application/pdf";
                else if (ext == "tif" || ext == "tiff") strContentType = "image/tiff";
                else if (ext == "jpg" || ext == "jpeg") strContentType = "image/jpeg";
                else if (ext == "mht" || ext == "mhtml") strContentType = "message/rfc822";
                else strContentType = "image/" + ext;

                //Response.Write(fileName + " : " + ext);
                //Response.End();

                strContentDispos = "inline;filename=" + fileName;
            }
            else
            {
                if (userAgent.IndexOf("MSIE") >= 0)
                {
                    if (userAgent.IndexOf("MSIE 5.0") >= 0)
                    {
                        strContentType = "application/x-msdownload";
                    }
                    else
                    {
                        strContentType = "application/unknown";
                    }
                }
                else
                {
                    strContentType = "application/unknown";
                }
                strContentDispos = "attachment;filename=" + fileName;
            }

            fileName = HttpUtility.UrlEncode(fileName, new UTF8Encoding()).Replace("+", "%20");

            Response.ContentType = strContentType;
            Response.ContentEncoding = System.Text.UTF8Encoding.UTF8; // 이미지 url이 깨지는 경우 발생 2010-07-06
            Response.AddHeader("Content-Disposition", strContentDispos);
            //Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
            //Response.AddHeader("Content-Disposition", "inline;filename=" + fileName);

            Response.CacheControl = "public";

            ZumNet.Framework.Log.Logging.WriteDebug(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), HttpContext.Current.Request.Url.AbsolutePath, "DownloadWithDotNet", realPath, Environment.NewLine));//Response.WriteFile(realPath);
            Response.TransmitFile(realPath);
            Response.Flush();
            Response.Close();
            //Response.WriteFile(realPath);
            Response.End();
        }

        //DextUpload를 이용한 내려받기
        private void DownloadWithDextUpload(string realPath, string fileName)
        {
            //using (DEXTUpload.NET.FileDownload fileDownload = new DEXTUpload.NET.FileDownload())
            //{
            //    fileDownload.Download(realPath, fileName, true, true);
            //}
        }

        /// <summary>
        /// 파일 암호화
        /// </summary>
        /// <param name="filePath"></param>
        private string EncrypFile(string filePath, string ext)
        {
            int iPos = Request.Url.AbsoluteUri.IndexOf("//");
            string strHttp = Request.Url.AbsoluteUri.Substring(0, iPos);
            strHttp += "//";

            string sEncrypServer = strHttp + Session["FrontName"].ToString() + (ZumNet.Framework.Configuration.Config.Read("drmPort") != "" ? ":" + ZumNet.Framework.Configuration.Config.Read("drmPort") : "");
            string strVPath = "/" + ZumNet.Framework.Configuration.Config.Read("UploadPath") + "/" + Session["URAccount"].ToString();
            string strUrl = String.Format("{0}/DocSecurity/?cvt={1}&rp={2}&df={3}&ext={4}", sEncrypServer, "enc", Server.UrlEncode(filePath), strVPath, ext);
            string strReturn = "";

            System.Net.HttpWebRequest HttpWReq = null;
            System.Net.HttpWebResponse HttpWResp = null;

            try
            {
                HttpWReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
                HttpWReq.Timeout = 5000;
                HttpWResp = (System.Net.HttpWebResponse)HttpWReq.GetResponse();
                using (System.IO.StreamReader sr = new System.IO.StreamReader(HttpWResp.GetResponseStream()))
                {
                    strReturn = sr.ReadToEnd();
                }
                HttpWResp.Close();

                if (strReturn.Substring(0, 2) != "OK")
                {
                    //22-08-06 임시로 암호화 실패 경우 로그 기록만
                    ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "EncrypFile", strUrl + " : " + strReturn, Environment.NewLine));
                    strReturn = filePath;
                }
                else strReturn = strReturn.Substring(2);
            }
            catch (Exception ex)
            {
                ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "EncrypFile", strUrl + " : " + ex.Message, Environment.NewLine));
                strReturn = filePath;
            }
            finally
            {
                HttpWReq = null;
                if (HttpWResp != null) { HttpWResp.Close(); HttpWResp = null; }
            }

            //2024-01-03 아래로 변경
            //string strVPath = "/" + ZumNet.Framework.Configuration.Config.Read("UploadPath") + "/" + Session["URAccount"].ToString();
            //string strReturn = "";

            //try
            //{
            //    strReturn = ZumNet.Web.Bc.CommonUtils.DocSecurity(filePath, "enc", ext, strVPath);
            //    if (strReturn.Substring(0, 2) != "OK")
            //    {
            //        ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "EncrypFile", filePath + " : " + strVPath + " : " + strReturn, Environment.NewLine));
            //        strReturn = filePath;
            //    }
            //    else strReturn = strReturn.Substring(2);
            //}
            //catch (Exception ex)
            //{
            //    ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "EncrypFile", filePath + " : " + strVPath + " : " + ex.Message, Environment.NewLine));
            //    strReturn = filePath;
            //}

            return strReturn;
        }
    }
}