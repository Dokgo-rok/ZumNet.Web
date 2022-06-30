using System;
using System.Collections;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Xml;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using ZumNet.Framework.Exception;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    /// <summary>
    /// 첨부파일 관련
    /// </summary>
    public class AttachmentsHandler
    {
        /// <summary>
        /// Attachments
        /// </summary>
        public AttachmentsHandler() { }

        /// <summary>
        /// 첨부파일 및 본문이미지 파일 저장소 처리
        /// </summary>
        /// <param name="dnId"></param>
        /// <param name="xfAlias"></param>
        /// <param name="fileInfo"></param>
        /// <param name="imgInfo"></param>
        /// <param name="body"></param>
        /// <returns></returns>
        public ZumNet.Framework.Core.ServiceResult TempToStorage(int dnId, string xfAlias, JArray fileInfo, JArray imgInfo, string body)
        {
            ZumNet.Framework.Core.ServiceResult svcRt = new Framework.Core.ServiceResult();
            
            string sFile = "";
            string[] vFile = null;
            char cDiv = (char)8;

            try
            {
                var jArr = new JArray();
                if (fileInfo != null && fileInfo.Count > 0)
                {
                    foreach (JObject j in fileInfo)
                    {
                        //string rt = DecrypFile(xfAlias, j["filepath"].ToString()); //오류 반환해도 그냥 통과

                        string sFileOrImg = j["isfile"].ToString() == "N" ? "Img" : "File";
                        sFile = TempToStorage(dnId, xfAlias, j["savedname"].ToString(), j["filepath"].ToString(), sFileOrImg);
                        if (sFile.Substring(0, 2) == "OK")
                        {
                            JObject jTemp = j;
                            vFile = sFile.Substring(2).Split(cDiv);
                            jTemp["prefix"] = vFile[2];
                            jTemp["location"] = vFile[3];
                            jTemp["savedname"] = vFile[1];
                            jTemp["storagefolder"] = vFile[0];

                            jArr.Add(jTemp);
                        }
                    }
                }
                svcRt.ResultDataDetail.Add("FileInfo", jArr);

                jArr = new JArray();
                string sBody = body;
                if (imgInfo != null && imgInfo.Count > 0)
                {
                    System.Text.RegularExpressions.Regex rgx = null;
                    string strPattern = "";

                    foreach (JObject j in imgInfo)
                    {
                        //sFile = InlineFileToStorage(dnId, j["origin"].ToString(),  xfAlias, j["imgname"].ToString(), j["imgpath"].ToString(), "Img");
                        sFile = InlineFileToStorage(dnId, j["origin"].ToString(), xfAlias, j["savedname"].ToString(), j["filepath"].ToString(), "Img");

                        if (sFile.Substring(0, 2) == "OK")
                        {
                            JObject jTemp = j;
                            vFile = sFile.Substring(2).Split(cDiv);
                            j["prefix"] = vFile[2];
                            j["location"] = vFile[3];
                            j["savedname"] = vFile[1];
                            j["storagefolder"] = vFile[0];
                            j["size"] = vFile[4];

                            jArr.Add(jTemp);

                            strPattern = @"src\s*=\s*""" + j["filepath"].ToString() + "\"";
                            rgx = new System.Text.RegularExpressions.Regex(strPattern);
                            sBody = rgx.Replace(sBody, "src=\"" + vFile[0] + "\"");
                        }
                    }
                }
                svcRt.ResultDataDetail.Add("ImgInfo", jArr);
                svcRt.ResultDataDetail.Add("Body", sBody);

            }
            catch(Exception ex)
            {
                svcRt.ResultCode = -1;
                svcRt.ResultMessage = ex.Message;

                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, System.Reflection.MethodBase.GetCurrentMethod().Name);
            }

            return svcRt;
        }

        /// <summary>
        /// 파일 임시폴더에서 저장소로 이동
        /// </summary>
        /// <param name="dnId"></param>
        /// <param name="xfAlias"></param>
        /// <param name="fileName"></param>
        /// <param name="filePath"></param>
        /// <param name="fileOrImg"></param>
        /// <returns></returns>
        private string TempToStorage(int dnId, string xfAlias, string fileName, string filePath, string fileOrImg)
        {
            ZumNet.Framework.Core.ServiceResult svcRt = null;
            FileInfo fi = null;

            int iLocId = 0;
            int iFolderNum = 0;
            char cDiv = (char)8;

            string strServer = "";
            string strFileFolder = "";
            string strImgFolder = "";
            string strNewDirPath = "";
            string strSourcePath = "";
            string strDestPath = "";
            string strSavedName = "";

            string strReturn = "";
            string sPos = "";

            try
            {
                sPos = "[100]";
                using (ZumNet.BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = comBiz.GetAttachFilePath(dnId, xfAlias, fileOrImg);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    sPos = "[200]";
                    iLocId = svcRt.ResultItemCount;
                    iFolderNum = xfAlias == "ea" ? svcRt.ResultItemCount / 1000 : svcRt.ResultItemCount / 250;

                    //192.168.100.249	newekp	storage\cresyn\Files\ea	389837	storage\cresyn\Images\ea	29023	G:
                    strServer = svcRt.ResultDataRow["ServerName"].ToString();
                    strFileFolder = svcRt.ResultDataRow["FileStorageFolder"].ToString();
                    strImgFolder = svcRt.ResultDataRow["ImgStorageFolder"].ToString();

                    if (fileOrImg.Equals("Img"))
                    {
                        sPos = "[210]";
                        strNewDirPath = strImgFolder + @"\" + iFolderNum.ToString();
                        //strSavedName = iLocID.ToString() + "_" + fileName;    //2011-08-30
                        strSavedName = fileName;    //DEXT5 Editor 사용시 iLocID 붙일 필요 없음

                        strSourcePath = HttpContext.Current.Server.MapPath(filePath);
                    }
                    else if (fileOrImg.Equals("File"))
                    {
                        sPos = "[220]";
                        strNewDirPath = strFileFolder + @"\" + iFolderNum.ToString();
                        if (xfAlias == "ea") strSavedName = ZumNet.Framework.Entities.Flow.ProcessStateChart.NewGuid();    //2010-07-06
                        else strSavedName = fileName; //DEXT5 Editor 사용시 iLocID 붙일 필요 없음

                        strSourcePath = HttpContext.Current.Server.MapPath(filePath); //filePath;
                    }

                    sPos = "[230]";
                    FileHelper.CreateDirectory(HttpContext.Current.Server.MapPath("/" + strNewDirPath));
                    strDestPath = HttpContext.Current.Server.MapPath("/" + strNewDirPath + @"\" + strSavedName);
                }
                else
                {
                    sPos = "[110]";
                    throw new Exception(svcRt.ResultMessage);
                }

                sPos = "[300]";
                fi = new FileInfo(strSourcePath);
                if (fi.Exists)
                {
                    fi.MoveTo(strDestPath);
                }
                else
                {
                    throw new Exception("첨부된 파일이 없습니다!");
                }

                sPos = "[400]";
                //newekp\storage\cresyn\Files\ea
                //\\newekp\storage\cresyn\Files\board\47
                //http://ekp.cresyn.com/storage/cresyn/Images/ea/28/28761_twe514.gif

                //결재 기준으로 저장
                if (xfAlias == "ea" || xfAlias == "tooling" || xfAlias == "ecnplan") strReturn = "OK" + strServer + "\\" + strFileFolder + cDiv + strSavedName + cDiv + iLocId.ToString() + cDiv + iFolderNum.ToString();
                else strReturn = "OK" + strServer + "\\" + strNewDirPath + cDiv + strSavedName + cDiv + iLocId.ToString() + cDiv + iFolderNum.ToString();
            }
            catch (Exception ex)
            {
                ex.Source = sPos + " " + ex.Source;
                ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }
            finally
            {
                fi = null;
            }

            return strReturn;
        }

        /// <summary>
        /// 본문 에디터 내 이미지, 동영상, 파일 저장소 이동
        /// </summary>
        /// <param name="dnId"></param>
        /// <param name="locationOrigin"></param>
        /// <param name="xfAlias"></param>
        /// <param name="fileName"></param>
        /// <param name="filePath"></param>
        /// <param name="fileOrImg"></param>
        /// <returns></returns>
        private string InlineFileToStorage(int dnId, string locationOrigin, string xfAlias, string fileName, string filePath, string fileOrImg)
        {
            ZumNet.Framework.Core.ServiceResult svcRt = null;
            FileInfo fi = null;

            int iLocId = 0;
            int iFolderNum = 0;
            char cDiv = (char)8;

            string strServer = "";
            string strImgFolder = "";
            string strNewDirPath = "";
            string strSourcePath = "";
            string strDestPath = "";
            string strSavedName = "";
            string strImgSize = "";

            string strReturn = "";
            string sPos = "";

            try
            {
                sPos = "[100]";
                using (ZumNet.BSL.ServiceBiz.CommonBiz comBiz = new BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = comBiz.GetAttachFilePath(dnId, xfAlias, fileOrImg);
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    sPos = "[200]";
                    iLocId = svcRt.ResultItemCount;
                    iFolderNum = xfAlias == "ea" ? svcRt.ResultItemCount / 1000 : svcRt.ResultItemCount / 250;

                    //192.168.100.249	newekp	storage\cresyn\Files\ea	389837	storage\cresyn\Images\ea	29023	G:
                    strServer = svcRt.ResultDataRow["ServerName"].ToString();
                    strImgFolder = svcRt.ResultDataRow["ImgStorageFolder"].ToString();

                    sPos = "[210]";
                    strNewDirPath = strImgFolder + @"\" + iFolderNum.ToString();
                    strSavedName = fileName;    //DEXT5 Editor 사용시 iLocID 붙일 필요 없음
                    strSourcePath = HttpContext.Current.Server.MapPath(filePath.Replace(locationOrigin, ""));

                    sPos = "[230]";
                    FileHelper.CreateDirectory(HttpContext.Current.Server.MapPath("/" + strNewDirPath));
                    strDestPath = HttpContext.Current.Server.MapPath("/" + strNewDirPath + @"\" + strSavedName);
                }
                else
                {
                    sPos = "[110]";
                    throw new Exception(svcRt.ResultMessage);
                }

                sPos = "[300]";
                fi = new FileInfo(strSourcePath);
                if (fi.Exists)
                {
                    strImgSize = fi.Length.ToString();
                    fi.MoveTo(strDestPath);
                }
                else
                {
                    throw new Exception("첨부된 파일이 없습니다!");
                }

                sPos = "[400]";


                //결재 기준으로 저장
                strReturn = "OK" + locationOrigin + "/" + strNewDirPath.Replace("\\", "/") + "/" + strSavedName + cDiv + strSavedName + cDiv + iLocId.ToString() + cDiv + iFolderNum.ToString() + cDiv + strImgSize;
            }
            catch (Exception ex)
            {
                ex.Source = sPos + " " + ex.Source;
                ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }
            finally
            {
                fi = null;
            }

            return strReturn;
        }

        /// <summary>
        /// 게시판 첨부파일 저장을 위한 xml 처리
        /// </summary>
        /// <param name="fileInfo"></param>
        /// <returns></returns>
        public string ConvertFileInfoToXml(JArray fileInfo)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<fileinfo>");
            foreach (JObject j in fileInfo)
            {
                sb.AppendFormat("<file atttype=\"{0}\" seq=\"{1}\" isfile=\"{2}\" size=\"{3}\" filetype=\"{4}\" prefix=\"{5}\" location=\"{6}\">"
                    , j["atttype"].ToString(), j["seq"].ToString(), j["isfile"].ToString(), j["size"].ToString(), j["ext"].ToString(), j["prefix"].ToString(), j["location"].ToString());
                sb.AppendFormat("<filename><![CDATA[{0}]]></filename>", j["filename"].ToString());
                sb.AppendFormat("<savedname><![CDATA[{0}]]></savedname>", j["savedname"].ToString());
                sb.AppendFormat("<storagefolder><![CDATA[{0}]]></storagefolder>", j["storagefolder"].ToString()); //storagefolder, fullpath -> category별로 틀림
                sb.AppendFormat("<fullpath><![CDATA[{0}]]></fullpath>", j["storagefolder"].ToString());
                sb.Append("</file>");
            }
            sb.Append("</fileinfo>");

            return sb.ToString();
        }

        /// <summary>
        /// DRM 복호화
        /// </summary>
        /// <param name="xfAlias"></param>
        /// <param name="filePath"></param>
        /// <returns></returns>
        private string DecrypFile(string xfAlias, string filePath)
        {
            string strReturn = "";

            if (Framework.Configuration.Config.Read("UseDRM") == "Y" && (xfAlias == "ea" || xfAlias == "doc" || xfAlias == "tooling" || xfAlias == "ecnplan"))
            {
                string sEncrypServer = HttpContext.Current.Session["FrontName"].ToString();
                string strUrl = String.Format("https://{0}/DocSecurity/?cvt={1}&rp={2}", sEncrypServer, "dec", HttpContext.Current.Server.UrlEncode(filePath));

                System.Net.HttpWebRequest HttpWReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
                System.Net.HttpWebResponse HttpWResp = (System.Net.HttpWebResponse)HttpWReq.GetResponse();
                using (System.IO.StreamReader sr = new System.IO.StreamReader(HttpWResp.GetResponseStream()))
                {
                    strReturn = sr.ReadToEnd();
                }
                HttpWResp.Close();

                if (strReturn.Substring(0, 2) == "OK")
                {
                    strReturn = strReturn.Substring(2);
                }
                else
                {
                    ExceptionManager.Publish(new Exception(strReturn), ExceptionManager.ErrorLevel.Error, "DecrypFile");
                }
            }
            return strReturn;
        }
    }
}