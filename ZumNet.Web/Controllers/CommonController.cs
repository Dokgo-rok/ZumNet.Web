using System;
using System.Collections.Generic;
using System.Data;
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
                    svcRt = cb.AddViewCount(jPost["xf"].ToString(), iFolderId, Convert.ToInt32(jPost["urid"]), Convert.ToInt32(jPost["mi"]), Request.ServerVariables["REMOTE_ADDR"]);
                }

                if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                else strView = "OK";
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

                    using (ZumNet.BSL.ServiceBiz.BoardBiz bb = new BSL.ServiceBiz.BoardBiz())
                    {
                        svcRt = bb.SetBoardMsgComment(jPost["xfalias"].ToString(), Convert.ToInt32(jPost["msgid"]), Convert.ToInt32(jPost["seqid"]), jPost["creurid"].ToString(), jPost["creur"].ToString(), jPost["comment"].ToString(), "");
                    }

                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else strView = "OK";
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
                        svcRt = bb.DeleteBoardMsgComment(jPost["xfalias"].ToString(), jPost["msgid"].ToString(), jPost["seqid"].ToString());
                    }

                    if (svcRt.ResultCode != 0) strView = svcRt.ResultMessage;
                    else strView = "OK";
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
    }
}