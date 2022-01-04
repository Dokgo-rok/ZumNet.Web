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

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    /// <summary>
    /// 양식 데이터 관련
    /// </summary>
    public static class FormHandler
    {
        /// <summary>
        /// Form Data Binding
        /// </summary>
        //public FormHandler() { }

        public static string BindFormToJson(this Controller ctrl, ZumNet.Framework.Core.ServiceResult formData)
        {
            string strReturn = "";
            JObject jV;
            DataRow mainInfo = null;
            DataTable coregInfo = null; //공동등록자
            DataTable fileInfo = null;
            DataTable replyInfo = null;
            DataTable cmntInfo = null;

            string sJsonPath = "";
            string sPrevApp = "";
            string sNextApp = "";
            string sPos = "";

            //if (ctrl.ViewBag.R.xfalias == "")
            //{
            //    return "No Form Alias!";
            //}

            if (ctrl.ViewBag.R.xfalias == "bbs" || ctrl.ViewBag.R.xfalias == "notice" || ctrl.ViewBag.R.xfalias == "file") sJsonPath = "~/Content/Json/jform_bbs.json";
            else if (ctrl.ViewBag.R.xfalias == "doc") sJsonPath = "~/Content/Json/jform_doc.json";
            else if (ctrl.ViewBag.R.xfalias == "knowledge") sJsonPath = "~/Content/Json/jform_knowledge.json";
            else if (ctrl.ViewBag.R.xfalias == "ea") sJsonPath = "~/Content/Json/jform_ea.json";
            else sJsonPath = "~/Content/Json/jform_bbs.json"; //xfalias='' 인 경우 일반게시 또는 공지사항으로 적용

            try
            {
                sPos = "100";
                using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath(sJsonPath)))
                {
                    jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                if (formData != null && formData.ResultDataSet != null && formData.ResultDataSet.Tables.Count > 0)
                {
                    sPos = "200";
                    mainInfo = formData.ResultDataSet.Tables["TBL_BOARD"].Rows[0];
                    if (ctrl.ViewBag.R.xfalias == "knowledge") coregInfo = formData.ResultDataSet.Tables["TBL_COREGIST"];
                    fileInfo = formData.ResultDataSet.Tables["TBL_FILE"];
                    replyInfo = formData.ResultDataSet.Tables["TBL_REPLY"];
                    cmntInfo = formData.ResultDataSet.Tables["TBL_COMMENT"];

                    sPos = "300";
                    if (formData.ResultDataDetail.ContainsKey("prevMsgID")) sPrevApp = formData.ResultDataDetail["prevMsgID"].ToString();
                    if (formData.ResultDataDetail.ContainsKey("nextMsgID")) sNextApp = formData.ResultDataDetail["nextMsgID"].ToString();

                    sPos = "400";
                    jV["parent"] = mainInfo["ParentMsgID"].ToString();
                    jV["prev"] = sPrevApp;
                    jV["next"] = sNextApp;
                    jV["att"] = mainInfo["AttType"].ToString();
                    jV["msg"] = mainInfo["MsgType"].ToString();
                    jV["priority"] = mainInfo["Priority"].ToString();
                    if (ctrl.ViewBag.R.xfalias == "knowledge") jV["state"] = mainInfo["State"].ToString();
                    jV["creur"] = mainInfo["CreatorName"].ToString();
                    jV["creurid"] = mainInfo["CreatorID"].ToString();
                    jV["creurcn"] = mainInfo["CreatorAccount"].ToString();
                    jV["cremail"] = "";
                    jV["creempid"] = "";
                    jV["cregrade"] = "";
                    jV["credept"] = mainInfo["CreatorDept"].ToString();
                    jV["credpid"] = "";
                    jV["credpcd"] = "";
                    jV["credate"] = mainInfo["CreateDate"].ToString();
                    jV["pubdate"] = mainInfo["PublishDate"].ToString();
                    jV["expdate"] = mainInfo["ExpiredDate"].ToString();
                    jV["popdate"] = mainInfo["PopUpDate"].ToString();

                    jV["subject"] = mainInfo["Subject"].ToString();
                    jV["body"] = mainInfo["Body"].ToString();
                    jV["seqid"] = mainInfo["SeqID"].ToString();
                    jV["depth"] = mainInfo["Depth"].ToString();
                    jV["topline"] = mainInfo["TopLine"].ToString();
                    jV["ispopup"] = mainInfo["IsPopup"].ToString();
                    jV["replymail"] = mainInfo["ReplyMail"].ToString();
                    jV["rsvd1"] = mainInfo["Reserved1"].ToString();
                    jV["rsvd2"] = mainInfo["Reserved2"].ToString();

                    //공동등록자
                    sPos = "500";
                    if (ctrl.ViewBag.R.xfalias == "knowledge")
                    {
                        if (coregInfo != null && coregInfo.Rows.Count > 0)
                        {
                            var jArr = new JArray();
                            foreach (DataRow dr in coregInfo.Rows)
                            {
                                JObject jTemp = JObject.Parse("{}");
                                jTemp["msgid"] = dr["MessageID"].ToString();
                                jTemp["xfalias"] = dr["XFAlias"].ToString();
                                jTemp["acttype"] = dr["ActType"].ToString();
                                jTemp["actorid"] = dr["ActorID"].ToString();
                                jTemp["actor"] = dr["Actor"].ToString();
                                jTemp["actorcn"] = dr["ActorCN"].ToString();
                                jTemp["actorgrade"] = dr["ActorGrade"].ToString();
                                jTemp["actordept"] = dr["ActorDept"].ToString();
                                jTemp["actordpid"] = dr["ActorDeptID"].ToString();
                                jTemp["actordpcd"] = dr["ActorDeptCode"].ToString();
                                jTemp["isread"] = dr["IsRead"].ToString();
                                jTemp["vewdate"] = dr["ViewDate"].ToString();
                                jTemp["rsvd1"] = dr["Reserved1"].ToString();

                                jArr.Add(jTemp);
                            }
                            jV["coreglist"] = jArr;
                            jV["coregcount"] = coregInfo.Rows.Count.ToString();
                        }
                        else
                        {
                            jV["coregcount"] = "0";
                        }
                    }

                    //첨부파일
                    sPos = "600";
                    if (fileInfo != null && fileInfo.Rows.Count > 0)
                    {
                        decimal dSum = 0;
                        var jArr = new JArray();
                        foreach (DataRow dr in fileInfo.Rows)
                        {
                            dSum += Convert.ToDecimal(dr["FileSize"]);

                            JObject jTemp = JObject.Parse("{}");
                            jTemp["attachid"] = dr["AttachID"].ToString();
                            jTemp["filename"] = dr["FileName"].ToString();
                            jTemp["savedname"] = dr["SavedName"].ToString();
                            jTemp["size"] = dr["FileSize"].ToString();
                            jTemp["ext"] = dr["FileType"].ToString();
                            jTemp["filepath"] = dr["FilePath"].ToString();
                            jTemp["storagefolder"] = dr["StorageFolder"].ToString();

                            jArr.Add(jTemp);

                        }
                        jV["attachlist"] = jArr;
                        jV["attachcount"] = fileInfo.Rows.Count.ToString();
                        jV["attachsize"] = CommonUtils.StrFileSize(dSum.ToString());
                    }
                    else
                    {
                        jV["attachcount"] = "0";
                        jV["attachsize"] = "";
                    }

                    //댓글
                    sPos = "700";
                    if (cmntInfo != null && cmntInfo.Rows.Count > 0)
                    {
                        var jArr = new JArray();
                        foreach (DataRow dr in cmntInfo.Rows)
                        {
                            JObject jTemp = JObject.Parse("{}");
                            jTemp["msgid"] = dr["MessageID"].ToString();
                            jTemp["xfalias"] = dr["XFAlias"].ToString();
                            jTemp["seqid"] = dr["SeqID"].ToString();
                            jTemp["creurid"] = dr["CreatorID"].ToString();
                            jTemp["creur"] = dr["Creator"].ToString();
                            jTemp["credate"] = dr["CreateDate"].ToString();
                            jTemp["comment"] = dr["Comment"].ToString();
                            jTemp["rsvd1"] = dr["Reserved1"].ToString();

                            jArr.Add(jTemp);
                        }
                        jV["cmntlist"] = jArr;
                        jV["cmntcount"] = mainInfo["CommentCount"].ToString();
                    }
                    else
                    {
                        jV["cmntcount"] = "0";
                    }

                    //답글
                    sPos = "800";
                    if (replyInfo != null && replyInfo.Rows.Count > 0)
                    {
                        var jArr = new JArray();
                        foreach (DataRow dr in replyInfo.Rows)
                        {
                            JObject jTemp = JObject.Parse("{}");
                            jTemp["msgid"] = dr["MessageID"].ToString();
                            jTemp["parent"] = dr["ParentMsgID"].ToString();
                            jTemp["seqid"] = dr["SeqID"].ToString();
                            jTemp["step"] = dr["Step"].ToString();
                            jTemp["depth"] = dr["Depth"].ToString();
                            jTemp["subject"] = dr["Subject"].ToString();
                            jTemp["displayname"] = dr["DisplayName"].ToString();
                            jTemp["viewcount"] = dr["ViewCount"].ToString();
                            jTemp["credate"] = dr["CreateDate"].ToString();
                            jTemp["state"] = dr["State"].ToString();

                            jArr.Add(jTemp);
                        }
                        jV["replylist"] = jArr;
                        jV["replycount"] = replyInfo.Rows.Count.ToString();
                    }
                    else
                    {
                        jV["replycount"] = "0";
                    }

                    jV["viewcount"] = mainInfo["ViewCount"].ToString();
                }

                sPos = "900";
                ctrl.ViewBag.R.app = jV;
            }
            catch(Exception ex)
            {
                strReturn = "[" + sPos + "] " + ex.Message;
            }
            finally
            {
                if (coregInfo != null) coregInfo.Dispose();
                if (fileInfo != null) fileInfo.Dispose();
                if (cmntInfo != null) cmntInfo.Dispose();
                if (replyInfo != null) replyInfo.Dispose();
            }

            return strReturn;
        }
    }
}