using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json.Linq;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Controllers
{
    public class CommonController : Controller
    {
        /// <summary>
        /// Ajax 폴더 트리구조 가져오기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Tree()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "필수값 누락!";
                }

                if (jPost["ct"].ToString() == "" || jPost["ct"].ToString() == "0")
                {
                    return "[CategoryID] 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                string sSelected = jPost["selected"].ToString() == "#" ? "" : jPost["selected"].ToString();
                int iLevel = StringHelper.SafeInt(jPost["lvl"], 0);

                //jstree ajax 방식일 경우 opennode 까지 폴더들을 미리 불러올 필요 없음 !! (StringHelper.SafeString(jPost["open"], ""))
                //selected : 0.0.13257, open : 0.0.12851
                //ResultDataDetail openNode 값 : 0.0.13257;0.0.12851

                using (ZumNet.BSL.ServiceBiz.CommonBiz com = new ZumNet.BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = com.GetTreeInformation(Convert.ToInt32(Session["DNID"]), Convert.ToInt32(jPost["ct"]), sSelected, StringHelper.SafeString(jPost["seltype"], "")
                                        , iLevel, Convert.ToInt32(Session["URID"]), StringHelper.SafeString(jPost["open"], "")
                                        , Session["Admin"].ToString(), StringHelper.SafeString(jPost["acl"], ""), 0, 0, "");
                }

                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    string sIconType = "";
                    StringBuilder sb = new StringBuilder();
                    sb.Append("[");

                    int i = 0;
                    string[] v = svcRt.ResultDataDetail["openNode"].ToString().Split(';');

                    foreach (DataRow row in svcRt.ResultDataRowCollection)
                    {
                        if (Convert.ToInt32(row["NodeLevel"]) >= iLevel + 2) break; //jstree ajax 처리시 여러 레벨 가져올 경우 오류 발생으로 막음

                        if (row["ObjectType"].ToString() == "CT") sIconType = "cat";
                        else if (row["ObjectType"].ToString() == "B" || row["ObjectType"].ToString() == "W" || row["ObjectType"].ToString() == "R") sIconType = "res";
                        else if (row["ObjectType"].ToString() == "C" || row["ObjectType"].ToString() == "D" || row["ObjectType"].ToString() == "T") sIconType = "group";
                        else if (row["ObjectType"].ToString() == "P") sIconType = "user";
                        else if (row["ObjectType"].ToString() == "S") sIconType = "sch";
                        else if (row["ObjectType"].ToString() == "L") sIconType = "lnk";
                        else
                        {
                            if (row["AttType"].ToString() == "S") sIconType = "short";
                            else if (row["AttType"].ToString() == "F") sIconType = "fav";
                            else if (row["Shared"].ToString() == "Y") sIconType = "shared";
                            else
                            {
                                //sIconType = (sSelected == row["NodeID"].ToString() || v.Contains(row["NodeID"].ToString())) ? "fdopen" : "fdclose";
                                sIconType = "folder";
                            }
                        }

                        if (i > 0) { sb.Append(",{"); }
                        else { sb.Append("{"); }

                        sb.AppendFormat("\"id\":\"{0}\"", row["NodeID"].ToString());
                        sb.AppendFormat(",\"parent\":\"{0}\"", row["MemberOf"].ToString() == "0.0.0" ? "#" : row["MemberOf"].ToString());
                        sb.AppendFormat(",\"text\":\"{0}\"", row["DisplayName"].ToString().Trim());
                        //sb.AppendFormat(",\"icon\":\"{0}\"", "");
                        sb.AppendFormat(",\"type\":\"{0}\"", sIconType);

                        if (sSelected == row["NodeID"].ToString())
                        {
                            sb.Append(",\"state\":{\"opened\":true,\"disabled\":false,\"selected\":true}");
                        }
                        else if (v.Contains(row["NodeID"].ToString()))
                        {
                            if (v[v.Length - 1] == row["NodeID"].ToString())
                            {
                                sb.Append(",\"state\":{\"opened\":true,\"disabled\":false,\"selected\":true}");
                            }
                            else
                            {
                                sb.Append(",\"state\":{\"opened\":true,\"disabled\":false,\"selected\":false}");
                            }
                        }
                        else
                        {
                            sb.Append(",\"state\":{\"opened\":false,\"disabled\":false,\"selected\":false}");
                        }
                        if (row["HasSub"].ToString() == "Y")
                            sb.Append(",\"children\": true");
                        else
                            sb.Append(",\"children\": false");

                        sb.Append(",\"li_attr\":{");
                        sb.AppendFormat("\"level\":\"{0}\"", row["NodeLevel"].ToString());
                        sb.AppendFormat(",\"objecttype\":\"{0}\"", row["ObjectType"].ToString());
                        sb.AppendFormat(",\"hassub\":\"{0}\"", row["HasSub"].ToString());
                        sb.AppendFormat(",\"alias\":\"{0}\"", row["Alias"].ToString());
                        sb.AppendFormat(",\"xfalias\":\"{0}\"", row["XFAlias"].ToString());
                        sb.AppendFormat(",\"shared\":\"{0}\"", row["Shared"].ToString());
                        sb.AppendFormat(",\"attype\":\"{0}\"", row["AttType"].ToString());
                        sb.AppendFormat(",\"inuse\":\"{0}\"", row["InUse"].ToString());
                        sb.AppendFormat(",\"acl\":\"{0}\"", row["Permission"].ToString());
                        sb.AppendFormat(",\"deleted\":\"{0}\"", row["Deleted"].ToString());
                        //sb.AppendFormat(",\"desc\":\"{0}\"", row["URL"].ToString());
                        sb.Append("}");
                        sb.Append(",\"a_attr\":{");
                        sb.AppendFormat("\"url\":\"{0}\"", row["URL"].ToString().Trim()); //jstree ajax 처리시 속성값에 공백/특수문자 있으면 오류 발생
                        sb.Append("}");
                        sb.Append("}");

                        i++;
                    }
                    sb.Append("]");

                    strView = sb.ToString();
                    //strView = JToken.Parse(sb.ToString()).ToString();
                    //strView = "{\"error\":\"오류메시지\"}";
                    //int i = 0;
                    //foreach (DataRow row in svcRt.ResultDataRowCollection)
                    //{
                    //    JObject j = new JObject();
                    //    j["id"] = row["NodeID"].ToString();
                    //    j["parent"] = row["MemberOf"].ToString() == "0.0.0" ? "#" : row["MemberOf"].ToString();
                    //    j["text"] = row["DisplayName"].ToString();
                    //    j["icon"] = "";
                    //    j["state"] = "";
                    //    j["li_attr"] = "";
                    //    j["a_attr"] = "";

                    //    jt[i] = j;

                    //    i++;
                    //}

                }
                else
                {
                    //에러페이지
                    strView = svcRt.ResultMessage;
                }
            }
            return strView;
        }

        /// <summary>
        /// Ajax 리스트뷰 가져오기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string List()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                int iCategoryId = Convert.ToInt32(jPost["ct"]);
                int iFolderId = Convert.ToInt32(jPost["tgt"]);

                switch (jPost["ot"].ToString())
                {
                    case "G":
                        switch (jPost["xf"].ToString())
                        {
                            case "notice":
                            case "bbs":
                            case "file":
                                using (ZumNet.BSL.ServiceBiz.BoardBiz bd = new BSL.ServiceBiz.BoardBiz())
                                {
                                    svcRt = bd.GetMessgaeListInfoAddTopLine(1, iCategoryId, iFolderId, Convert.ToInt32(Session["URID"]), Session["Admin"].ToString()
                                                , jPost["permission"].ToString(), Convert.ToInt32(jPost["page"]), Convert.ToInt32(jPost["cnt"]), "SeqID", "DESC", "", "", "", "");
                                }
                                break;

                            default:
                                break;
                        }

                        break;

                    case "F":

                        break;

                    default:
                        break;
                }
            }

            return strView;
        }

        /// <summary>
        /// 게시물 조회 기록
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string AddViewCount()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["xf"]) == "" || StringHelper.SafeString(jPost["urid"]) == "" || StringHelper.SafeString(jPost["mi"]) == "")
                {
                    return "필수값 누락!";
                }

                int iFolderId = StringHelper.SafeInt(jPost["fdid"]);
                ZumNet.Framework.Core.ServiceResult svcRt = null;

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    if (jPost["xf"].ToString() == "anonymous") svcRt = cb.AddViewCount(jPost["xf"].ToString(), 0, 0, Convert.ToInt32(jPost["mi"]), "", Session.SessionID);
                    else svcRt = cb.AddViewCount(jPost["xf"].ToString(), iFolderId, Convert.ToInt32(jPost["urid"]), Convert.ToInt32(jPost["mi"]), Request.ServerVariables["REMOTE_ADDR"]);
                }

                if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                else strView = "OK";
            }

            return strView;
        }

        /// <summary>
        /// 게시물 좋아요 기록
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SetLike()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["xf"]) == "" || StringHelper.SafeString(jPost["mi"]) == "")
                {
                    return "필수값 누락!";
                }

                ZumNet.Framework.Core.ServiceResult svcRt = null;

                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    if (jPost["xf"].ToString() == "anonymous") svcRt = cb.SetLikeEvent(jPost["xf"].ToString(), Convert.ToInt32(jPost["mi"]), Session.SessionID, Convert.ToInt32(jPost["point"]));
                    else svcRt = cb.SetLikeEvent(jPost["xf"].ToString(), Convert.ToInt32(jPost["mi"]), jPost["urid"].ToString(), Convert.ToInt32(jPost["point"]));
                }

                if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                else strView = "OK";
            }

            return strView;
        }

        /// <summary>
        /// 각종 게시물 삭제 처리
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DeleteMsg()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["xf"]) == "" || StringHelper.SafeString(jPost["urid"]) == "" || StringHelper.SafeString(jPost["mi"]) == "")
                {
                    return "필수값 누락!";
                }

                int iFolderId = StringHelper.SafeInt(jPost["fdid"]);
                ZumNet.Framework.Core.ServiceResult svcRt = null;

                using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                {
                    if (jPost["xf"].ToString() == "anonymous")
                    {
                        svcRt = bb.GetAnonyMsgPwd(jPost["mi"].ToString(), jPost["xf"].ToString());

                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else if (jPost["pwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;

                        svcRt = null;
                    }

                    if (strView == "") svcRt = bb.DelBoardMessage(iFolderId, Convert.ToInt32(Session["DNID"]), jPost["xf"].ToString(), jPost["mi"].ToString(), Convert.ToInt32(jPost["urid"]));
                }

                if (strView == "")
                {
                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else strView = "OK";
                }   
            }

            return strView;
        }

        #region [댓글 관련]
        /// <summary>
        /// 댓글 등록
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string AddComment()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["xfalias"]) == "" || StringHelper.SafeString(jPost["msgid"]) == "" || StringHelper.SafeString(jPost["seqid"]) == "" || StringHelper.SafeString(jPost["comment"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;                    
                    int iSeqId = StringHelper.SafeInt(jPost["seqid"].ToString());                    

                    using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (jPost["xfalias"].ToString() == "anonymous")
                        {
                            if (iSeqId > 0 && jPost.ContainsKey("prevpwd"))
                            {
                                svcRt = bb.GetCommentMessagePassword(jPost["msgid"].ToString(), jPost["xfalias"].ToString(), iSeqId);

                                if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                                else if (jPost["prevpwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;

                                svcRt = null;
                            }

                            if (strView == "") svcRt = bb.SetAnonyMsgComment(jPost["xfalias"].ToString(), jPost["msgid"].ToString(), iSeqId, jPost["creur"].ToString(), jPost["pwd"].ToString(), jPost["comment"].ToString());
                        } 
                        else svcRt = bb.SetBoardMsgComment(jPost["xfalias"].ToString(), Convert.ToInt32(jPost["msgid"]), iSeqId, jPost["creurid"].ToString(), jPost["creur"].ToString(), jPost["comment"].ToString(), "");
                    }

                    if (strView == "")
                    {
                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else strView = "OK";
                    }                        
                }
                catch(Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }

        /// <summary>
        /// 댓글 삭제
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DeleteComment()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["xfalias"]) == "" || StringHelper.SafeString(jPost["msgid"]) == "" || StringHelper.SafeString(jPost["seqid"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                    {
                        if (jPost["xfalias"].ToString() == "anonymous")
                        {
                            svcRt = bb.GetCommentMessagePassword(jPost["msgid"].ToString(), jPost["xfalias"].ToString(), StringHelper.SafeInt(jPost["seqid"].ToString()));

                            if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                            else if (jPost["pwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;

                            svcRt = null;
                        }

                        if (strView == "") svcRt = bb.DeleteBoardMsgComment(jPost["xfalias"].ToString(), jPost["msgid"].ToString(), jPost["seqid"].ToString());
                    }

                    if (strView == "")
                    {
                        if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                        else strView = "OK";
                    }   
                }
                catch (Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }

        /// <summary>
        /// 댓글 비밀번호 확인
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string CheckCommentPwd()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    JObject jPost = CommonUtils.PostDataToJson();

                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (StringHelper.SafeString(jPost["xfalias"]) == "" || StringHelper.SafeString(jPost["msgid"]) == "" || StringHelper.SafeString(jPost["seqid"]) == "")
                    {
                        return "필수값 누락!";
                    }

                    ZumNet.Framework.Core.ServiceResult svcRt = null;

                    using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bb.GetCommentMessagePassword(jPost["msgid"].ToString(), jPost["xfalias"].ToString(), StringHelper.SafeInt(jPost["seqid"].ToString()));
                    }

                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else
                    {
                        if (jPost["pwd"].ToString() != svcRt.ResultDataString) strView = "NO" + Resources.Global.Password_NotMatch;
                        else strView = "OK"; 
                    }
                }
                catch (Exception ex)
                {
                    strView = ex.Message;
                }
            }

            return strView;
        }
        #endregion

        /// <summary>
        /// 게시물 미리보기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Preview()
        {
            return View();
        }

        #region [CODE_DESCRIPTION 테이블 관련]
        /// <summary>
        /// 코드 추가, 변경
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string SetCode()
        {
            string strView = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();

                if (jPost == null || jPost.Count == 0)
                {
                    return "전송 데이터 누락!";
                }
                else if (StringHelper.SafeString(jPost["k1"]) == "" || StringHelper.SafeString(jPost["k2"]) == "" || StringHelper.SafeString(jPost["k3"]) == "" || StringHelper.SafeString(jPost["item1"]) == "")
                {
                    return "필수값 누락!";
                }

                string sMode = StringHelper.SafeString(jPost["M"]); //I : insert, U : update, D : delete

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                {
                    if (sMode == "")
                    {
                        svcRt = cb.SelectCodeDescription(jPost["k1"].ToString(), jPost["k2"].ToString(), jPost["k3"].ToString());
                        sMode = (svcRt.ResultDataSet != null && svcRt.ResultDataSet.Tables.Count > 0 && svcRt.ResultDataSet.Tables[0].Rows.Count > 0) ? "U" : "I";
                    }

                    svcRt = cb.HandleCodeDescription(sMode, jPost["k1"].ToString(), jPost["k2"].ToString(), jPost["k3"].ToString()
                                    , jPost["item1"].ToString(), StringHelper.SafeString(jPost["item2"]), StringHelper.SafeString(jPost["item3"])
                                    , StringHelper.SafeString(jPost["item4"]), StringHelper.SafeString(jPost["item5"]));
                }

                if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                else strView = "OK";
            }

            return strView;
        }
        #endregion

        #region [파일첨부 및 가져오기 관련]
        /// <summary>
        /// 파일 첨부
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public ActionResult Upload()
        {
            //long lOneSize = Convert.ToInt64(ZumNet.Framework.Configuration.Config.Read("MaxUploadSize"));
            //long lMaxSize = Convert.ToInt64(ZumNet.Framework.Configuration.Config.Read("MaxUploadTotalSize"));
            //long lSize = 0;
            //long lSum = 0;

            //string rt = "";

            //HttpFileCollectionBase files = Request.Files;
            //for (int i = 0; i > files.Count; i++)
            //{
            //    HttpPostedFileBase f = files[i];
            //    if (f != null)
            //    {
            //        lSize = StringHelper.CvtByte(f.ContentLength, "MB");
            //        if (lSize >= lOneSize)
            //        {
            //            rt = "파일크기는 " + lOneSize.ToString() + "M를 넘을 수 없습니다!";
            //            break;
            //        }
            //        else
            //        {
            //            lSum += lSize;
            //        }
            //    }
            //}

            //if (rt == "")
            //{
            //    if (lSum >= lMaxSize) rt = "전체 파일크기는 " + lOneSize.ToString() + "M를 넘을 수 없습니다!";
            //    else
            //    {
            //        string sUploadPath = "/" + ZumNet.Framework.Configuration.Config.Read("UploadPath") + "/" + Session["LogonID"].ToString();
            //        ZumNet.Framework.Web.Utility.SetUploadFolder(sUploadPath);

            //        for (int i = 0; i > files.Count; i++)
            //        {
            //            HttpPostedFileBase f = files[i];
            //            if (f != null)
            //            {
            //                var inputFileName = Path.GetFileName(f.FileName);
            //                var tempSavePath = Path.Combine(Server.MapPath(sUploadPath) + "/" + inputFileName);

            //                f.SaveAs(tempSavePath);
            //            }   
            //        }
            //    }
            //}
            
            return View("_Upload");
        }

        /// <summary>
        /// Web Form 파일 내려받기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult DownloadV()
        {
            //Web Form 방식
            return View("_Download");
        }

        /// <summary>
        /// MVC 파일 내려받기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult Download()
        {
            //MVC 방식
            int _attachId = 0;
            bool _disableDocSecurity = false; //기본 보안설정

            string sPos = "[100]";
            string sUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
            string sRealPath = Request["fp"] != null && Request["fp"].ToString() != "" ? SecurityHelper.Base64Decode(Request["fp"].ToString()).Replace(@"\", "/") : "";
            string sFileName = Request["fn"] != null && Request["fn"].ToString() != "" ? SecurityHelper.Base64Decode(Request["fn"].ToString()) : "";
            string sXFAlias = Request["xf"] != null && Request["xf"].ToString() != "" ? StringHelper.SafeString(Request["xf"]) : "";
            string sSavedName = Request["sn"] != null && Request["sn"].ToString() != "" ? StringHelper.SafeString(Request["sn"]) : "";

            try
            {
                if (sXFAlias != "" && sSavedName != "")
                {
                    sPos = "[200]";
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

                        int iPos = sRealPath.IndexOf(@"\");
                        sRealPath = sRealPath.Substring(iPos);

                        //2020-02-04 문서보안해제신청서 양식 첨부파일 결재 완료 후 7일 이내 보안해제
                        _attachId = Convert.ToInt32(dr["AttachID"]);
                        if (dr["DisableSecurity"].ToString() == "Y")
                        {
                            _disableDocSecurity = true;
                        }
                    }
                }
                else
                {
                    sRealPath = Server.MapPath(sRealPath);
                }

                sPos = "[300]";
                //2014-06-19 크레신, pdf는 DRM 적용이 돼 있을 수 있으므로 제외
                string[] vFile = sFileName.Split('.');
                string ext = vFile[vFile.Length - 1].ToLower();

                //2019-05-31 첨부경로 확인
                if (!System.IO.File.Exists(sRealPath))
                {
                    sRealPath = sRealPath.ToLower().Replace(@"\storage\", @"\Archive\");
                }

                //2020-10-27 스토리지 2차 추가로 인한 경로 추가확인
                if (!System.IO.File.Exists(sRealPath))
                {
                    sRealPath = sRealPath.ToLower().Replace(@"\Archive\", @"\ArchiveD\");
                }

                sPos = "[400]";
                using (ZumNet.DAL.FlowDac.EApprovalDac eaDac = new ZumNet.DAL.FlowDac.EApprovalDac())
                {
                    eaDac.InsertEventFileView(_attachId, sFileName, sSavedName, sRealPath, Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString()
                                , Session["URName"].ToString(), Request.ServerVariables["REMOTE_HOST"], sUserAgent, (_disableDocSecurity ? "Y" : "N"));
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

                sPos = "[500]";
                byte[] fileBytes = System.IO.File.ReadAllBytes(sRealPath);
                string strContentType = "";

                sPos = "[510]";
                if (ext == "pdf") strContentType = System.Net.Mime.MediaTypeNames.Application.Pdf;
                else if (ext == "zip") strContentType = System.Net.Mime.MediaTypeNames.Application.Zip;
                else strContentType = System.Net.Mime.MediaTypeNames.Application.Octet;
                
                strContentType = MimeMapping.GetMimeMapping(sFileName);

                sPos = "[520]";
                sFileName = HttpUtility.UrlEncode(sFileName, new UTF8Encoding()).Replace("+", "%20");

                //FilePathResult fp = new FilePathResult(sRealPath, strContentType);
                

                if (ext == "pdf" || ext == "tif" || ext == "tiff" || ext == "jpg" || ext == "jpeg" || ext == "bmp"
                     || ext == "gif" || ext == "png" || ext == "mht" || ext == "mhtml" || ext == "htm" || ext == "html")
                {
                    sPos = "[600]";
                    return File(fileBytes, strContentType, sFileName); //sFileName 없으면 바로 열기 가능하나 다운로드파일명은 없게 됨
                }
                else
                {
                    sPos = "[610]";
                    return File(fileBytes, strContentType, sFileName);
                }   
            }
            catch(Exception ex)
            {
                ex.Source = sPos + " " + ex.Source;
                return View("~/Views/Shared/_Error.cshtml", new HandleErrorInfo(ex, this.RouteData.Values["controller"].ToString(), this.RouteData.Values["action"].ToString()));
            }
        }

        /// <summary>
        /// 첨부파일 삭제
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string DeleteAttach()
        {
            string strView = "";
            string sPos = "";

            if (Request.IsAjaxRequest())
            {
                try
                {
                    sPos = "[100]";
                    JObject jPost = CommonUtils.PostDataToJson();
                    if (jPost == null || jPost.Count == 0)
                    {
                        return "전송 데이터 누락!";
                    }
                    else if (!jPost.ContainsKey("tgtid") && !jPost.ContainsKey("fp"))
                    {
                        return "필수값 누락!";
                    }

                    int iFolderId = StringHelper.SafeInt(jPost["fdid"]);

                    sPos = "[200]";
                    ZumNet.Framework.Core.ServiceResult svcRt = null;
                    using (ZumNet.BSL.ServiceBiz.CommonBiz cb = new BSL.ServiceBiz.CommonBiz())
                    {
                        if (jPost["xf"].ToString() != "" && jPost["tgtid"].ToString() != "" && jPost.ContainsKey("appid") && jPost["appid"].ToString() != "")
                        {
                            sPos = "[210]";
                            svcRt = cb.DeleteAttachFile(jPost["xf"].ToString(), jPost["tgtid"].ToString(), Convert.ToInt32(Session["DNID"]), StringHelper.SafeInt(jPost["fdid"]), StringHelper.SafeInt(jPost["appid"]));
                        }
                        else if (jPost["tgtid"].ToString() != "")
                        {
                            sPos = "[220]";
                            svcRt = cb.DeleteAttachFile(jPost["xf"].ToString(), Convert.ToInt32(jPost["tgtid"]));
                        }
                    }

                    sPos = "[300]";
                    if (svcRt != null && svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else
                    {
                        sPos = "[310]";
                        if (jPost.ContainsKey("fp") && StringHelper.SafeString(jPost["fp"].ToString()) != "")
                        {
                            sPos = "[320]";
                            string sRealPath = Server.MapPath(SecurityHelper.Base64Decode(Server.UrlDecode(jPost["fp"].ToString())));
                            FileHelper.DeleteFile(sRealPath);
                        }
                        strView = "OK";
                    }
                }
                catch(Exception ex)
                {
                    strView = sPos + " " + ex.Message;
                }
            }

            return strView;
        }

        /// <summary>
        /// 파일 가져오기
        /// </summary>
        /// <returns></returns>
        [SessionExpireFilter]
        [Authorize]
        public ActionResult FileImport(string Qi)
        {
            return View("_FileImport");
        }

        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public ActionResult FileImport()
        {
            return View("_FileImport");
        }
        #endregion

        #region [파일 암복호화]
        /// <summary>
        /// 파일 암호화
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="ext"></param>
        /// <returns></returns>
        private string EncrypFile(string filePath, string ext)
        {
            int iPos = Request.Url.AbsoluteUri.IndexOf("//");
            string strHttp = Request.Url.AbsoluteUri.Substring(0, iPos);
            strHttp += "//";

            string sEncrypServer = strHttp + Session["FrontName"].ToString();
            string strVPath = "/" + ZumNet.Framework.Configuration.Config.Read("UploadPath") + "/" + Session["URAccount"].ToString();
            string strUrl = String.Format("{0}/DocSecurity/?cvt={1}&rp={2}&df={3}&ext={4}", sEncrypServer, "enc", Server.UrlEncode(filePath), strVPath, ext);
            string strReturn = "";

            System.Net.HttpWebRequest HttpWReq = null;
            System.Net.HttpWebResponse HttpWResp = null;

            try
            {
                HttpWReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
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

            return strReturn;
        }

        /// <summary>
        /// 파일 복호화
        /// </summary>
        /// <param name="filePath"></param>
        private void DecrypFile(string filePath)
        {
            int iPos = Request.Url.AbsoluteUri.IndexOf("//");
            string strHttp = Request.Url.AbsoluteUri.Substring(0, iPos);
            strHttp += "//";

            string sEncrypServer = strHttp + Session["FrontName"].ToString();
            string strUrl = String.Format("{0}/DocSecurity/?cvt={1}&rp={2}", sEncrypServer, "dec", Server.UrlEncode(filePath));
            string strResult = "";

            System.Net.HttpWebRequest HttpWReq = null;
            System.Net.HttpWebResponse HttpWResp = null;

            try
            {
                HttpWReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
                HttpWResp = (System.Net.HttpWebResponse)HttpWReq.GetResponse();
                using (System.IO.StreamReader sr = new System.IO.StreamReader(HttpWResp.GetResponseStream()))
                {
                    strResult = sr.ReadToEnd();
                }
                HttpWResp.Close();

                if (strResult.Substring(0, 2) != "OK")
                {
                    //22-08-06 임시로 암호화 실패 경우 로그 기록만
                    ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "DecrypFile", strUrl + " : " + strResult, Environment.NewLine));
                }
            }
            catch (Exception ex)
            {
                ZumNet.Framework.Log.Logging.WriteLog(String.Format("{0, -15}{1} => {2}, {3}{4}", DateTime.Now.ToString("HH:mm:ss.ff"), Request.Url.AbsolutePath, "DecrypFile", strUrl + " : " + ex.Message, Environment.NewLine));
            }
            finally
            {
                HttpWReq = null;
                if (HttpWResp != null) { HttpWResp.Close(); HttpWResp = null; }
            }
        }
        #endregion

        /// <summary>
        /// 주소 공공데이터 팝업
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        public ActionResult JusoPopup()
        {
            return View();
        }
    }
}