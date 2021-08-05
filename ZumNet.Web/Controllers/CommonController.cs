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

                ZumNet.Framework.Core.ServiceResult svcRt = null;
                string sSelected = jPost["selected"].ToString() == "#" ? "" : jPost["selected"].ToString();
                int iLevel = StringHelper.SafeInt(jPost["lvl"], 0);

                using (ZumNet.BSL.ServiceBiz.CommonBiz com = new ZumNet.BSL.ServiceBiz.CommonBiz())
                {
                    svcRt = com.GetTreeInformation(1, StringHelper.SafeInt(jPost["ct"], 103), sSelected
                                        , StringHelper.SafeString(jPost["seltype"], ""), iLevel
                                        , StringHelper.SafeInt(jPost["ur"], 101374), StringHelper.SafeString(jPost["open"], "")
                                        , "Y", "", 0, 0, "");
                }
                
                if (svcRt != null && svcRt.ResultCode == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("[");

                    int i = 0;
                    string[] v = svcRt.ResultDataDetail["openNode"].ToString().Split(';');

                    foreach (DataRow row in svcRt.ResultDataRowCollection)
                    {
                        if (Convert.ToInt32(row["NodeLevel"]) >= iLevel + 2) break; //jstree ajax 처리시 여러 레벨 가져올 경우 오류 발생으로 막음

                        if (i > 0) { sb.Append(",{"); }
                        else { sb.Append("{"); }

                        sb.AppendFormat("\"id\":\"{0}\"", row["NodeID"].ToString());
                        sb.AppendFormat(",\"parent\":\"{0}\"", row["MemberOf"].ToString() == "0.0.0" ? "#" : row["MemberOf"].ToString());
                        sb.AppendFormat(",\"text\":\"{0}\"", row["DisplayName"].ToString());
                        sb.AppendFormat(",\"icon\":\"{0}\"", "");

                        if (v.Contains(row["NodeID"].ToString()))
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
                        sb.AppendFormat(",\"permission\":\"{0}\"", row["Permission"].ToString());
                        sb.AppendFormat(",\"deleted\":\"{0}\"", row["Deleted"].ToString());
                        sb.Append("}");
                        sb.Append(",\"a_attr\":{");
                        sb.AppendFormat("\"url\":\"{0}\"", row["URL"].ToString());
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
    }
}