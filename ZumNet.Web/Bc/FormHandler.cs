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

using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    /// <summary>
    /// 양식 데이터 관련
    /// </summary>
    public static class FormHandler
    {
        #region [양식 JSON 변환 : 게시판, 지식관리]
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
            //else if (ctrl.ViewBag.R.xfalias == "doc") sJsonPath = "~/Content/Json/jform_doc.json";
            else if (ctrl.ViewBag.R.xfalias == "knowledge") sJsonPath = "~/Content/Json/jform_knowledge.json";
            //else if (ctrl.ViewBag.R.xfalias == "ea") sJsonPath = "~/Content/Json/jform_ea.json";
            else sJsonPath = "~/Content/Json/jform_bbs.json"; //xfalias='' 인 경우 일반게시 또는 공지사항으로 적용

            try
            {
                sPos = "100";
                using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath(sJsonPath)))
                {
                    jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                if (formData != null)
                {
                    if (ctrl.ViewBag.R.mode.ToString() == "reply")
                    {
                        sPos = "200";
                        mainInfo = formData.ResultDataRow;

                        sPos = "400";
                        jV["parent"] = ctrl.ViewBag.R.appid;
                        jV["subject"] = "답글: " + mainInfo["Subject"].ToString();
                        //jV["body"] = mainInfo["Body"].ToString();
                    }
                    else if (formData.ResultDataSet != null && formData.ResultDataSet.Tables.Count > 0)
                    {
                        sPos = "210";
                        mainInfo = formData.ResultDataSet.Tables["TBL_BOARD"].Rows[0];
                        if (ctrl.ViewBag.R.xfalias == "knowledge") coregInfo = formData.ResultDataSet.Tables["TBL_COREGIST"];
                        fileInfo = formData.ResultDataSet.Tables["TBL_FILE"];
                        replyInfo = formData.ResultDataSet.Tables["TBL_REPLY"];
                        cmntInfo = formData.ResultDataSet.Tables["TBL_COMMENT"];

                        sPos = "300";
                        if (formData.ResultDataDetail.ContainsKey("prevMsgID")) sPrevApp = formData.ResultDataDetail["prevMsgID"].ToString();
                        if (formData.ResultDataDetail.ContainsKey("nextMsgID")) sNextApp = formData.ResultDataDetail["nextMsgID"].ToString();

                        sPos = "410";
                        jV["parent"] = mainInfo["ParentMsgID"].ToString();
                        jV["prev"] = sPrevApp;
                        jV["next"] = sNextApp;
                        jV["att"] = mainInfo["AttType"].ToString();
                        jV["msg"] = mainInfo["MsgType"].ToString();
                        jV["priority"] = mainInfo["Priority"].ToString();

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
                            jV["state"] = mainInfo["State"].ToString();
                            jV["coregurid"] = mainInfo["CoRegistrant"].ToString();

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
                                dSum += Convert.ToDecimal(StringHelper.SafeDecimal(dr["FileSize"]));

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
                                jTemp["creurcn"] = dr["CreatorCN"].ToString();
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
        #endregion

        #region [문서관리 JSON 변환]
        public static string BindDocToJson(this Controller ctrl, ZumNet.Framework.Core.ServiceResult formData)
        {
            string strReturn = "";
            JObject jV;
            DataRow mainInfo = null;
            DataTable fileInfo = null;
            DataTable aclInfo = null;
            DataTable cmntInfo = null;

            XmlDocument xmlDoc = null;

            string sJsonPath = "~/Content/Json/jform_doc.json";
            string sPos = "";

            try
            {
                sPos = "100";
                using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath(sJsonPath)))
                {
                    jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                if (formData != null)
                {
                    if (formData.ResultDataSet != null && formData.ResultDataSet.Tables.Count > 0)
                    {
                        sPos = "210";
                        mainInfo = formData.ResultDataSet.Tables["TBL_BOARD"].Rows[0];
                        fileInfo = formData.ResultDataSet.Tables["TBL_FILE"];
                        aclInfo = formData.ResultDataSet.Tables["TBL_ACL"];
                        cmntInfo = formData.ResultDataSet.Tables["TBL_COMMENT"];

                        //MessageID, FD_ID, MsgType, Subject, CreatorID, CoCreateGR, CreatorDept, ISNULL(D.EditDate, CreateDate) AS DocDate
                        //HasAttachFile, Creator AS CreatorName, B.DisplayName, C.Body, ProcessState AS State, E.Reserved1, E.Reserved2, AttType, Inherited
                        //ParentMsgID, SeqID, Step, Depth, State, CommentCount, ViewCount, EvalCount

                        sPos = "300";
                        jV["parent"] = mainInfo["ParentMsgID"].ToString();
                        jV["att"] = mainInfo["AttType"].ToString();
                        jV["msg"] = mainInfo["MsgType"].ToString();
                        jV["priority"] = "";
                        jV["state"] = mainInfo["State"].ToString();

                        jV["creur"] = mainInfo["CreatorName"].ToString();
                        jV["creurid"] = mainInfo["CreatorID"].ToString();
                        jV["creurcn"] = "";
                        jV["cremail"] = "";
                        jV["creempid"] = "";
                        jV["cregrade"] = "";
                        jV["credept"] = mainInfo["CreatorDept"].ToString();
                        jV["credpid"] = "";
                        jV["credpcd"] = "";
                        jV["docdate"] = mainInfo["DocDate"].ToString();
                        jV["pubdate"] = "";

                        jV["subject"] = mainInfo["Subject"].ToString();
                        jV["body"] = mainInfo["Body"].ToString();
                        jV["seqid"] = mainInfo["SeqID"].ToString();
                        jV["depth"] = mainInfo["Depth"].ToString();
                        jV["topline"] = "";
                        jV["ispopup"] = "";
                        jV["replymail"] = "";
                        jV["rsvd1"] = mainInfo["Reserved1"].ToString();
                        jV["rsvd2"] = mainInfo["Reserved2"].ToString();
                        jV["viewcount"] = mainInfo["ViewCount"].ToString();

                        //권한
                        sPos = "500";
                        if (aclInfo != null && aclInfo.Rows.Count > 0)
                        {
                            var jArr = new JArray();
                            foreach (DataRow dr in aclInfo.Rows)
                            {
                                JObject jTemp = JObject.Parse("{}");
                                jTemp["tgtid"] = dr["TargetID"].ToString();
                                jTemp["tgttype"] = dr["TargetType"].ToString();
                                jTemp["tgtname"] = dr["TargetName"].ToString();
                                jTemp["acl"] = dr["AclKind"].ToString();
                                jTemp["desc"] = dr["Description"].ToString();
                                jTemp["tgtalias"] = dr["TargetAlias"].ToString();

                                jArr.Add(jTemp);
                            }
                            jV["acllist"] = jArr;
                        }

                        //첨부파일
                        sPos = "600";
                        if (fileInfo != null && fileInfo.Rows.Count > 0)
                        {
                            decimal dSum = 0;
                            var jArr = new JArray();
                            foreach (DataRow dr in fileInfo.Rows)
                            {
                                dSum += Convert.ToDecimal(StringHelper.SafeDecimal(dr["FileSize"]));

                                sPos = "610";
                                JObject jTemp = JObject.Parse("{}");
                                jTemp["attachid"] = dr["AttachID"].ToString();
                                jTemp["filename"] = dr["FileName"].ToString();
                                jTemp["savedname"] = dr["SavedName"].ToString();
                                jTemp["size"] = dr["FileSize"].ToString();
                                jTemp["ext"] = dr["FileType"].ToString();
                                jTemp["filepath"] = dr["FilePath"].ToString();
                                jTemp["storagefolder"] = "";

                                sPos = "620";
                                //B.IsOriginal, B.Ver, B.IsBase, B.AutoDeleted, B.IsLocked, B.DocLevel, B.KeepYear, B.DocNumber
                                //, DATEADD(yy, B.KeepYear, B.RegisteredDate) AS ExhaustDate, B.RegisteredDate
                                //, C.DisplayName AS DocLevelName, D.DisplayName AS KeepYearName
                                jTemp["isoriginal"] = dr["IsOriginal"].ToString().Trim();
                                jTemp["ver"] = dr["Ver"].ToString();
                                jTemp["isbase"] = dr["IsBase"].ToString().Trim();
                                jTemp["autodeleted"] = dr["AutoDeleted"].ToString().Trim();
                                jTemp["islocked"] = dr["IsLocked"].ToString().Trim();
                                jTemp["doclevel"] = dr["DocLevel"].ToString();
                                jTemp["keepyear"] = dr["KeepYear"].ToString();
                                jTemp["docnumber"] = dr["DocNumber"].ToString().Trim();
                                jTemp["exhdate"] = CommonUtils.CheckDateTime(dr["ExhaustDate"].ToString(), "yyyy-MM-dd HH:mm:ss", "");
                                jTemp["regdate"] = CommonUtils.CheckDateTime(dr["RegisteredDate"].ToString(), "yyyy-MM-dd HH:mm:ss", "");
                                jTemp["docleveltext"] = dr["DocLevelName"].ToString();
                                jTemp["keepyeartext"] = dr["KeepYearName"].ToString();

                                jTemp["courid"] = dr["CheckOutUserID"].ToString();
                                jTemp["parentid"] = dr["ParentAttachID"].ToString();

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
                                jTemp["creurcn"] = dr["CreatorCN"].ToString();
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

                        //결재선 정보
                        sPos = "800";
                        if (formData.ResultDataDetail["eaSignLIne"] != null && formData.ResultDataDetail["eaSignLIne"].ToString() != "")
                        {
                            xmlDoc = new XmlDocument();
                            xmlDoc.LoadXml("<lines>" + formData.ResultDataDetail["eaSignLIne"].ToString() + "</lines>");

                            sPos = "810";
                            JArray jLine = new JArray();
                            foreach (XmlNode line in xmlDoc.SelectNodes("line"))
                            {
                                JObject jData = new JObject();
                                foreach (XmlAttribute attr in line.Attributes)
                                {
                                    jData[attr.Name] = attr.Value;
                                }

                                foreach (XmlNode node in line.ChildNodes)
                                {
                                    jData[node.Name] = node.InnerText;
                                }
                                jLine.Add(jData);
                            }
                            jV["ealine"] = jLine;
                        }
                    }
                }

                sPos = "900";
                ctrl.ViewBag.R.app = jV;
            }
            catch (Exception ex)
            {
                strReturn = "[" + sPos + "] " + ex.Message;
            }
            finally
            {
                if (aclInfo != null) aclInfo.Dispose();
                if (fileInfo != null) fileInfo.Dispose();
                if (cmntInfo != null) cmntInfo.Dispose();
            }

            return strReturn;
        }
        #endregion

        #region [임시저장 게시물 JSON 변환]
        public static string BindTempFormToJson(this Controller ctrl, ZumNet.Framework.Core.ServiceResult formData)
        {
            string strReturn = "";
            JObject jV;
            DataRow mainInfo = null;
            DataTable fileInfo = null;

            string sJsonPath = "~/Content/Json/jform_bbs.json";
            string sPos = "";

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
                    fileInfo = formData.ResultDataSet.Tables["TBL_FILE"];

                    sPos = "300";
                    jV["priority"] = mainInfo["Priority"].ToString();
                    jV["creur"] = mainInfo["CreatorName"].ToString();
                    jV["creurid"] = mainInfo["CreatorID"].ToString();
                    jV["credept"] = mainInfo["CreatorDept"].ToString();
                    jV["credate"] = mainInfo["CreateDate"].ToString();
                    jV["pubdate"] = mainInfo["PublishDate"].ToString();
                    jV["expdate"] = mainInfo["ExpiredDate"].ToString();
                    jV["popdate"] = mainInfo["PopUpDate"].ToString();

                    sPos = "310";
                    jV["subject"] = mainInfo["Subject"].ToString();
                    jV["body"] = mainInfo["Body"].ToString();
                    jV["topline"] = mainInfo["TopLine"].ToString();
                    jV["ispopup"] = mainInfo["IsPopup"].ToString();
                    jV["replymail"] = mainInfo["ReplyMail"].ToString();
                    jV["rsvd1"] = mainInfo["Reserved1"].ToString();
                    jV["rsvd2"] = mainInfo["Reserved2"].ToString();

                    //첨부파일
                    sPos = "600";
                    if (fileInfo != null && fileInfo.Rows.Count > 0)
                    {
                        decimal dSum = 0;
                        var jArr = new JArray();
                        foreach (DataRow dr in fileInfo.Rows)
                        {
                            dSum += Convert.ToDecimal(StringHelper.SafeDecimal(dr["FileSize"]));

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

                    sPos = "610";
                    jV["cmntcount"] = mainInfo["CommentCount"].ToString();
                    jV["viewcount"] = mainInfo["ViewCount"].ToString();
                }

                sPos = "900";
                ctrl.ViewBag.R.app = jV;
            }
            catch (Exception ex)
            {
                strReturn = "[" + sPos + "] " + ex.Message;
            }
            finally
            {
                if (fileInfo != null) fileInfo.Dispose();
            }

            return strReturn;
        }
        #endregion

        #region [일정, 자원 JSON 변환]
        public static string BindScheduleToJson(this Controller ctrl, ZumNet.Framework.Core.ServiceResult formData)
        {
            string strReturn = "";
            JObject jV;
            DataRow mainInfo = null;
            DataTable partInfo = null;
            DataTable fileInfo = null;
            DataTable sharedInfo = null;
            DataTable cmntInfo = null;

            string sJsonPath = "~/Content/Json/jform_schedule.json"; //xfalias='' 인 경우 일반게시 또는 공지사항으로 적용
            string sPos = "";

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
                    mainInfo = formData.ResultDataSet.Tables[0].Rows[0];
                    partInfo = formData.ResultDataSet.Tables[1];
                    fileInfo = formData.ResultDataSet.Tables[2];
                    sharedInfo = formData.ResultDataSet.Tables[3];

                    sPos = "300";
                    jV["dnid"] = "";
                    jV["ot"] = "";
                    jV["otid"] = "";
                    jV["schtype"] = mainInfo["SchType"].ToString();
                    jV["task"] = mainInfo["TaskID"].ToString();
                    jV["inherited"] = mainInfo["Inherited"].ToString();
                    jV["state"] = mainInfo["State"].ToString();
                    jV["priority"] = mainInfo["Priority"].ToString().Trim();
                    
                    jV["creur"] = mainInfo["DisplayName"].ToString();
                    jV["creurid"] = mainInfo["CreatorID"].ToString();
                    jV["creurcn"] = mainInfo["MailAccount"].ToString();
                    jV["cremail"] = mainInfo["MailAccount"].ToString();
                    jV["creempid"] = "";
                    jV["cregrade"] = "";
                    jV["credept"] = mainInfo["CreatorDept"].ToString();
                    jV["credpid"] = mainInfo["CreatorDeptID"].ToString();
                    jV["credpcd"] = "";
                    jV["credate"] = mainInfo["CreateDate"].ToString();

                    sPos = "310";
                    jV["subject"] = mainInfo["Subject"].ToString();
                    jV["location"] = mainInfo["Location"].ToString();
                    jV["body"] = mainInfo["Body"].ToString();                    
                    jV["periodfrom"] = mainInfo["PeriodFrom"].ToString();
                    jV["start"] = mainInfo["StartTime"].ToString();
                    jV["periodto"] = mainInfo["PeriodTo"].ToString();
                    jV["end"] = mainInfo["EndTime"].ToString();
                    jV["term"] = mainInfo["Term"].ToString();
                    jV["alarm"] = mainInfo["Alarm"].ToString();
                    jV["rsvd1"] = ""; // mainInfo["Reserved1"].ToString();

                    sPos = "320";
                    jV["repeat"]["type"] = mainInfo["RepeatType"].ToString();
                    jV["repeat"]["end"] = mainInfo["RepeatEnd"].ToString().Trim();
                    jV["repeat"]["count"] = mainInfo["RepeatCount"].ToString();
                    jV["repeat"]["intervaltype"] = mainInfo["IntervalType"].ToString().Trim();
                    jV["repeat"]["interval"] = mainInfo["Interval"].ToString().Trim();
                    jV["repeat"]["conday"] = mainInfo["Con_Day"].ToString().Trim();
                    jV["repeat"]["conweek"] = mainInfo["Con_Week"].ToString().Trim();
                    jV["repeat"]["condate"] = mainInfo["Con_Date"].ToString().Trim();
                    jV["repeat"]["rsvd1"] = "";

                    //참여자
                    sPos = "400";
                    if (partInfo != null && partInfo.Rows.Count > 0)
                    {
                        var jArr = new JArray();
                        foreach (DataRow dr in partInfo.Rows)
                        {
                            JObject jTemp = JObject.Parse("{}");
                            jTemp["ot"] = dr["ObjectType"].ToString();
                            jTemp["partid"] = dr["ParticipantID"].ToString();
                            jTemp["partdn"] = dr["DisplayName"].ToString();
                            jTemp["partmail"] = dr["Mail"].ToString();
                            jTemp["parttype"] = dr["PartType"].ToString();
                            jTemp["state"] = dr["State"].ToString();
                            jTemp["confirmed"] = dr["Confirmed"].ToString();
                            jTemp["sendmail"] = dr["SendMail"].ToString();
                            jTemp["approval"] = dr["Approval"].ToString();

                            jArr.Add(jTemp);
                        }
                        jV["partlist"] = jArr;
                        jV["partcount"] = partInfo.Rows.Count.ToString();
                    }
                    else
                    {
                        jV["partcount"] = "0";
                    }

                    //첨부파일
                    sPos = "500";
                    if (fileInfo != null && fileInfo.Rows.Count > 0)
                    {
                        decimal dSum = 0;
                        var jArr = new JArray();
                        foreach (DataRow dr in fileInfo.Rows)
                        {
                            dSum += Convert.ToDecimal(StringHelper.SafeDecimal(dr["FileSize"]));

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

                    //공유정보
                    sPos = "600";
                    if (sharedInfo != null && sharedInfo.Rows.Count > 0)
                    {
                        var jArr = new JArray();
                        foreach (DataRow dr in sharedInfo.Rows)
                        {
                            JObject jTemp = JObject.Parse("{}");
                            jTemp["ot"] = dr["ObjectType"].ToString();
                            jTemp["otid"] = dr["ObjectID"].ToString();
                            jTemp["att"] = dr["AttType"].ToString();
                            jTemp["shared"] = dr["Shared"].ToString();
                            jTemp["display"] = dr["DisplayName"].ToString();

                            jArr.Add(jTemp);
                        }
                        jV["sharedlist"] = jArr;
                        jV["sharedcount"] = sharedInfo.Rows.Count.ToString();
                    }
                    else
                    {
                        jV["sharedcount"] = "0";
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
                            //jTemp["creurcn"] = dr["CreatorCN"].ToString();
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

                    //jV["viewcount"] = mainInfo["ViewCount"].ToString();
                }

                sPos = "800";
                ctrl.ViewBag.R.app = jV;
            }
            catch (Exception ex)
            {
                strReturn = "[" + sPos + "] " + ex.Message;
            }
            finally
            {
                if (partInfo != null) partInfo.Dispose();
                if (fileInfo != null) fileInfo.Dispose();
                if (sharedInfo != null) sharedInfo.Dispose();
                if (cmntInfo != null) cmntInfo.Dispose();
            }

            return strReturn;
        }
        #endregion

        #region [결재 양식 JSON 변환]
        /// <summary>
        /// 결재양식 XML => JSON 변환
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="xfDef"></param>
        /// <param name="formData"></param>
        /// <returns></returns>
        public static JObject BindEAFormToJson(Framework.Entities.Flow.XFormDefinition xfDef, XmlNode formData)
        {
            JObject jV = null;

            XmlNode oConfig = null;
            XmlNode oBizInfo = null;
            XmlNode oDocInfo = null;
            XmlNode oCategoryInfo = null;
            XmlNode oCreator = null;
            XmlNode oCurrentInfo = null;
            XmlNode oFormInfo = null;
            XmlNode oFileInfo = null;
            XmlNode oLinkedDoc = null;
            XmlNode oProcessInfo = null;
            XmlNode oOptionInfo = null;
            XmlNode oSchemaInfo = null;

            XmlNode oNode = null;

            string sPos = "";
            decimal dSum = 0;

            try
            {
                sPos = "100";
                oConfig = formData.SelectSingleNode("config");
                oBizInfo = formData.SelectSingleNode("bizinfo");
                oDocInfo = formData.SelectSingleNode("docinfo");
                oCategoryInfo = formData.SelectSingleNode("categoryinfo");
                oCreator = formData.SelectSingleNode("creatorinfo");
                oCurrentInfo = formData.SelectSingleNode("currentinfo");
                oFormInfo = formData.SelectSingleNode("forminfo");
                oFileInfo = formData.SelectSingleNode("fileinfo");
                oLinkedDoc = formData.SelectSingleNode("linkeddocinfo");
                oProcessInfo = formData.SelectSingleNode("processinfo");
                oOptionInfo = formData.SelectSingleNode("optioninfo");
                oSchemaInfo = formData.SelectSingleNode("schemainfo");

                sPos = "200";
                using (StreamReader reader = File.OpenText(HttpContext.Current.Server.MapPath("~/Content/Json/jform_ea.json")))
                {
                    jV = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                sPos = "300";
                jV["mode"] = oConfig.Attributes["mode"].Value;
                jV["submode"] = oConfig.Attributes["submode"].Value;
                jV["root"] = oConfig.Attributes["root"].Value;
                jV["companycode"] = oConfig.Attributes["companycode"].Value;
                jV["web"] = oConfig.Attributes["web"].Value;
                jV["domain"] = HttpContext.Current.Session["MainSuffix"].ToString();

                jV["dnid"] = HttpContext.Current.Session["DNID"].ToString();
                jV["partid"] = oConfig.Attributes["partid"].Value;
                jV["actid"] = oConfig.Attributes["actid"].Value; //2022-06-07 추가
                jV["biz"] = oConfig.Attributes["bizrole"].Value;
                jV["act"] = oConfig.Attributes["actrole"].Value;
                jV["wid"] = oConfig.Attributes["wid"].Value;
                //jV["wnid"] = "";
                jV["ft"] = xfDef.MainTable.Replace("FORM_", "");

                jV["parent"] = oBizInfo.Attributes["parent_oid"].Value;
                jV["oid"] = oBizInfo.Attributes["oid"].Value;
                jV["appid"] = oBizInfo.Attributes["msgid"].Value;
                jV["inherited"] = oBizInfo.Attributes["inherited"].Value;
                jV["priority"] = oBizInfo.Attributes["priority"].Value;
                jV["secret"] = oBizInfo.Attributes["secret"].Value;
                jV["docstatus"] = oBizInfo.Attributes["docstatus"].Value;
                jV["doclevel"] = oBizInfo.Attributes["doclevel"].Value; //코드값 저장
                jV["keepyear"] = oBizInfo.Attributes["keepyear"].Value; //코드값 저장
                jV["tms"] = oBizInfo.Attributes["tms"].Value;
                jV["prevwork"] = oBizInfo.Attributes["prevwork"].Value;
                jV["nextwork"] = oBizInfo.Attributes["nextwork"].Value;
                jV["piname"] = oBizInfo.SelectSingleNode("name").InnerText;
                jV["showline"] = oConfig.Attributes["showline"].Value;
                jV["boundary"] = CommonUtils.BOUNDARY();

                sPos = "400";
                jV["def"]["formid"] = xfDef.FormID;
                jV["def"]["processid"] = xfDef.ProcessID.ToString();
                jV["def"]["ver"] = xfDef.Version.ToString();
                jV["def"]["maintable"] = xfDef.MainTable;
                jV["def"]["subtablecount"] = xfDef.SubTableCount;
                jV["def"]["iscommon"] = xfDef.IsCommon;
                jV["def"]["usage"] = xfDef.Usage;
                jV["def"]["webeditor"] = xfDef.WebEditor;
                jV["def"]["css"] = xfDef.CssName;
                jV["def"]["js"] = xfDef.JsName;
                jV["def"]["html"] = xfDef.HtmlFile;
                jV["def"]["naming"] = xfDef.ProcessNameString;
                jV["def"]["validation"] = xfDef.Validation;
                jV["def"]["rsvd1"] = xfDef.Reserved1;

                sPos = "410";
                jV["doc"]["docname"] = oDocInfo.SelectSingleNode("docname").InnerText;
                jV["doc"]["msgtype"] = oDocInfo.SelectSingleNode("msgtype").InnerText;
                jV["doc"]["docnumber"] = oDocInfo.SelectSingleNode("docnumber").InnerText;
                jV["doc"]["doclevel"] = oDocInfo.SelectSingleNode("doclevel").InnerText;  //표기값 저장
                jV["doc"]["keepyear"] = oDocInfo.SelectSingleNode("keepyear").InnerText;  //표기값 저장
                jV["doc"]["subject"] = oDocInfo.SelectSingleNode("subject").InnerText;
                jV["doc"]["credate"] = oDocInfo.SelectSingleNode("createdate").InnerText;
                jV["doc"]["pubdate"] = oDocInfo.SelectSingleNode("publishdate").InnerText;
                jV["doc"]["expdate"] = oDocInfo.SelectSingleNode("expireddate").InnerText;
               
                //jV["doc"]["cmntcount"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                //jV["doc"]["viewcount"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                //jV["doc"]["evalcount"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                //jV["doc"]["linkmsg"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                //jV["doc"]["transfer"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                //jV["doc"]["logging"] = oDocInfo.SelectSingleNode("reserved2").InnerText;
                jV["doc"]["key1"] = oDocInfo.SelectSingleNode("externalkey1").InnerText;
                jV["doc"]["key2"] = oDocInfo.SelectSingleNode("externalkey2").InnerText;
                jV["doc"]["rsvd1"] = oDocInfo.SelectSingleNode("reserved1").InnerText;
                jV["doc"]["rsvd2"] = oDocInfo.SelectSingleNode("reserved2").InnerText;

                sPos = "420";
                jV["creator"]["urid"] = oCreator.Attributes["uid"].Value;
                jV["creator"]["urcn"] = oCreator.Attributes["account"].Value;
                jV["creator"]["deptid"] = oCreator.Attributes["deptid"].Value;
                jV["creator"]["deptcd"] = oCreator.Attributes["deptcode"].Value;
                jV["creator"]["user"] = oCreator.SelectSingleNode("name").InnerText;
                jV["creator"]["dept"] = oCreator.SelectSingleNode("department").InnerText;
                jV["creator"]["empno"] = oCreator.SelectSingleNode("empno").InnerText;
                jV["creator"]["grade"] = oCreator.SelectSingleNode("grade").InnerText;
                jV["creator"]["phone"] = oCreator.SelectSingleNode("phone").InnerText;
                jV["creator"]["belong"] = oCreator.SelectSingleNode("belong").InnerText;
                jV["creator"]["indate"] = oCreator.SelectSingleNode("indate").InnerText;
                if (oCreator.SelectSingleNode("corp") != null)
                {
                    JObject corp = new JObject();
                    foreach(XmlNode node in oCreator.SelectSingleNode("corp").ChildNodes)
                    {
                        corp[node.Name] = node.InnerText;
                    }
                    jV["creator"]["corp"] = corp;
                }

                sPos = "430";
                jV["current"]["urid"] = oCurrentInfo.Attributes["uid"].Value;
                jV["current"]["urcn"] = oCurrentInfo.Attributes["account"].Value;
                jV["current"]["deptid"] = oCurrentInfo.Attributes["deptid"].Value;
                jV["current"]["deptcd"] = oCurrentInfo.Attributes["deptcode"].Value;
                jV["current"]["user"] = oCurrentInfo.SelectSingleNode("name").InnerText;
                jV["current"]["dept"] = oCurrentInfo.SelectSingleNode("department").InnerText;
                jV["current"]["empno"] = oCurrentInfo.SelectSingleNode("empno").InnerText;
                jV["current"]["grade"] = oCurrentInfo.SelectSingleNode("grade").InnerText;
                jV["current"]["phone"] = oCurrentInfo.SelectSingleNode("phone").InnerText;
                jV["current"]["belong"] = oCurrentInfo.SelectSingleNode("belong").InnerText;
                jV["current"]["indate"] = oCurrentInfo.SelectSingleNode("indate").InnerText;
                jV["current"]["date"] = oCurrentInfo.Attributes["date"].Value; //DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

                sPos = "500";
                oNode = oFormInfo.SelectSingleNode("maintable");
                if (oNode != null && oNode.HasChildNodes)
                {
                    JObject jData = new JObject();
                    foreach(XmlNode node in oNode.ChildNodes)
                    {
                        jData[node.Name] = node.InnerText;
                    }
                    jV["form"]["maintable"] = jData;
                }

                sPos = "510";
                oNode = oFormInfo.SelectSingleNode("subtables");
                if (oNode != null && oNode.HasChildNodes)
                {
                    int iSub = 0;
                    JObject jSub = new JObject();
                    foreach (XmlNode sub in oNode.ChildNodes)
                    {
                        iSub++;
                        JArray jSub2 = new JArray();
                        foreach (XmlNode sub2 in sub.SelectNodes("row"))
                        {
                            JObject jData = new JObject();
                            foreach (XmlNode node in sub2.ChildNodes)
                            {
                                jData[node.Name] = node.InnerText;
                            }
                            jSub2.Add(jData);
                        }

                        jSub["subtable" + iSub.ToString()] = jSub2;
                    }
                    jV["form"]["subtables"] = jSub;
                }

                sPos = "600";
                oNode = oProcessInfo.SelectSingleNode("signline/lines");
                if (oNode != null && oNode.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oNode.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["process"]["signline"] = jSub;
                }

                sPos = "610";
                oNode = oProcessInfo.SelectSingleNode("attributes");
                if (oNode != null && oNode.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oNode.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["process"]["attributes"] = jSub;
                }

                sPos = "620";
                if (oSchemaInfo != null && oSchemaInfo.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oSchemaInfo.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            if (node.Name.IndexOf("cdata-section") >= 0) jData["name"] = node.InnerText;
                            else jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["schema"] = jSub;
                }

                sPos = "700";
                if (oFileInfo != null && oFileInfo.HasChildNodes)
                {
                    dSum = 0;
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oFileInfo.ChildNodes)
                    {
                        dSum += Convert.ToDecimal(sub.Attributes["size"].Value);
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["attachlist"] = jSub;
                    jV["doc"]["attachcount"] = oFileInfo.ChildNodes.Count;
                    jV["doc"]["attachsize"] = CommonUtils.StrFileSize(dSum.ToString());
                }
                else
                {
                    jV["doc"]["attachcount"] = "0";
                    jV["doc"]["attachsize"] = "";
                }

                sPos = "710";
                if (oCategoryInfo != null && oCategoryInfo.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oCategoryInfo.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["category"] = jSub;
                }

                sPos = "720";
                if (oLinkedDoc != null && oLinkedDoc.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oLinkedDoc.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["linkeddoc"] = jSub;
                }

                sPos = "800";
                if (oOptionInfo != null && oOptionInfo.HasChildNodes)
                {
                    string[] vNodeName = { "foption", "foption1", "foption2", "foption3" };
                    JArray jSub = new JArray();
                    foreach(string nodeName in vNodeName)
                    {
                        foreach (XmlNode sub in oOptionInfo.SelectNodes(nodeName))
                        {
                            JObject jData = new JObject();
                            foreach (XmlAttribute attr in sub.Attributes)
                            {
                                jData[attr.Name] = attr.Value;
                            }

                            foreach (XmlNode node in sub.ChildNodes)
                            {
                                jData[node.Name] = node.InnerText;
                            }
                            jSub.Add(jData);
                        }
                    }
                    jV["option"] = jSub;
                }
            }
            catch (Exception ex)
            {
                ex.Source = "[" + sPos + "] " + ex.Source;
                Framework.Exception.ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }
            finally
            {
                oConfig = null;
                oBizInfo = null;
                oDocInfo = null;
                oCategoryInfo = null;
                oCreator = null;
                oCurrentInfo = null;
                oFormInfo = null;
                oFileInfo = null;
                oLinkedDoc = null;
                oProcessInfo = null;
                oOptionInfo = null;
                oSchemaInfo = null;

                oNode = null;
            }

            return jV;
        }
        #endregion

        #region [금형, ECN 양식 JSON 변환]
        /// <summary>
        /// 금형, ECN 양식 XML => JSON 변환
        /// </summary>
        /// <param name="ctrl"></param>
        /// <param name="xfDef"></param>
        /// <param name="formData"></param>
        /// <returns></returns>
        public static JObject BindNotEAFormToJson(XmlNode formData)
        {
            JObject jV = null;

            XmlNode oConfig = null;
            XmlNode oCurrentInfo = null;
            XmlNode oFormInfo = null;
            XmlNode oFileInfo = null;
            XmlNode oOptionInfo = null;
            
            XmlNode oNode = null;

            string sPos = "";
            decimal dSum = 0;

            try
            {
                sPos = "100";
                oConfig = formData.SelectSingleNode("config");
                oCurrentInfo = formData.SelectSingleNode("current");
                oFormInfo = formData.SelectSingleNode("forminfo");
                oFileInfo = formData.SelectSingleNode("fileinfo");
                oOptionInfo = formData.SelectSingleNode("optioninfo");

                sPos = "200";
                jV = JObject.Parse("{\"current\":{},\"form\":{}}");

                sPos = "300";
                jV["mode"] = oConfig.Attributes["mode"].Value;
                jV["web"] = oConfig.Attributes["web"].Value;
                jV["root"] = oConfig.Attributes["root"].Value;
                jV["companycode"] = oConfig.Attributes["company"].Value;
                jV["domain"] = HttpContext.Current.Session["MainSuffix"].ToString();
                jV["dnid"] = HttpContext.Current.Session["DNID"].ToString();
                jV["oid"] = oConfig.Attributes["oid"].Value;
                jV["relid"] = oConfig.Attributes["relid"].Value;
                jV["appid"] = oConfig.Attributes["msgid"].Value;
                jV["formid"] = oConfig.Attributes["formid"].Value;
                jV["xfalias"] = oConfig.Attributes["xfalias"].Value;
                jV["wnid"] = oConfig.Attributes["wnid"].Value;
                jV["acl"] = oConfig.Attributes["acl"].Value;
                
                sPos = "400";
                jV["current"]["urid"] = oCurrentInfo.Attributes["uid"].Value;
                jV["current"]["urcn"] = oCurrentInfo.Attributes["account"].Value;
                jV["current"]["deptid"] = oCurrentInfo.Attributes["deptid"].Value;
                jV["current"]["deptcd"] = oCurrentInfo.Attributes["deptcode"].Value;
                jV["current"]["user"] = oCurrentInfo.SelectSingleNode("name").InnerText;
                jV["current"]["dept"] = oCurrentInfo.SelectSingleNode("depart").InnerText;
                jV["current"]["belong"] = oCurrentInfo.SelectSingleNode("belong").InnerText;
                jV["current"]["date"] = oCurrentInfo.Attributes["date"].Value;

                sPos = "500";
                oNode = oFormInfo.SelectSingleNode("maintable");
                if (oNode != null && oNode.HasChildNodes)
                {
                    JObject jData = new JObject();
                    foreach (XmlNode node in oNode.ChildNodes)
                    {
                        jData[node.Name] = node.InnerText;
                    }
                    jV["form"]["maintable"] = jData;
                }

                sPos = "510";
                oNode = oFormInfo.SelectSingleNode("subtables");
                if (oNode != null && oNode.HasChildNodes)
                {
                    int iSub = 0;
                    JObject jSub = new JObject();
                    foreach (XmlNode sub in oNode.ChildNodes)
                    {
                        iSub++;
                        JArray jSub2 = new JArray();
                        foreach (XmlNode sub2 in sub.SelectNodes("row"))
                        {
                            JObject jData = new JObject();
                            foreach (XmlNode node in sub2.ChildNodes)
                            {
                                jData[node.Name] = node.InnerText;
                            }
                            jSub2.Add(jData);
                        }

                        jSub["subtable" + iSub.ToString()] = jSub2;
                    }
                    jV["form"]["subtables"] = jSub;
                }

                sPos = "600";
                if (oFileInfo != null && oFileInfo.HasChildNodes)
                {
                    dSum = 0;
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oFileInfo.ChildNodes)
                    {
                        dSum += Convert.ToDecimal(sub.Attributes["size"].Value);
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["attachlist"] = jSub;
                    jV["attachcount"] = oFileInfo.ChildNodes.Count;
                    jV["attachsize"] = CommonUtils.StrFileSize(dSum.ToString());
                }
                else
                {
                    jV["attachcount"] = "0";
                    jV["attachsize"] = "";
                }

                sPos = "800";
                if (oOptionInfo != null && oOptionInfo.HasChildNodes)
                {
                    JArray jSub = new JArray();
                    foreach (XmlNode sub in oOptionInfo.ChildNodes)
                    {
                        JObject jData = new JObject();
                        foreach (XmlAttribute attr in sub.Attributes)
                        {
                            jData[attr.Name] = attr.Value;
                        }

                        foreach (XmlNode node in sub.ChildNodes)
                        {
                            jData[node.Name] = node.InnerText;
                        }
                        jSub.Add(jData);
                    }
                    jV["option"] = jSub;
                }
            }
            catch (Exception ex)
            {
                ex.Source = "[" + sPos + "] " + ex.Source;
                Framework.Exception.ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }
            finally
            {
                oConfig = null;
                oCurrentInfo = null;
                oFormInfo = null;
                oFileInfo = null;
                oOptionInfo = null;

                oNode = null;
            }

            return jV;
        }
        #endregion
    }
}