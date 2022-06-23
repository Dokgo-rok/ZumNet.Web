using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Mvc;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using ZumNet.BSL.ServiceBiz;
using ZumNet.BSL.InterfaceBiz;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Core;
using ZumNet.Framework.Exception;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Areas.EA.Controllers
{
    public class CommonController : Controller
    {
        // GET: EA/Common
        [SessionExpireFilter]
        [HttpPost]
        [Authorize]
        public string Index()
        {
            string rt = "";

            if (Request.IsAjaxRequest())
            {
                JObject jPost = CommonUtils.PostDataToJson();
                if (jPost == null || jPost.Count == 0 || jPost["M"].ToString() == "") return "필수값 누락!";

                switch (jPost["M"].ToString())
                {
                    case "gettopgroup":
                        rt = GetTopGroup(jPost);
                        break;
                    case "getcodedescription":
                        rt = GetCodeDescription(jPost);
                        break;

                    case "getreportsearch":
                        rt = GetReportSearch(jPost);
                        break;

                    default:
                        break;
                }
            }

            return rt;
        }

        #region [현 부서의 최상위 부서정보 가져오기]
        private string GetTopGroup(JObject postData)
        {
            string strReturn = "필수항목 누락!";
            if (!postData.ContainsKey("gid") || postData["gid"].ToString() == "") return strReturn;

            ServiceResult svcRt = new ServiceResult();

            try
            {
                string strQuery = "SELECT TOP 1 dn FROM (SELECT * FROM admin.ph_fn_GetParentGRTableForEA(" + Session["DNID"].ToString() + ",'D', '" + postData["gid"].ToString() + "', '" + DateTime.Now.ToString("yyyy-MM-dd") + "')) a ORDER BY LEV DESC";
                using (ExecuteBiz excBiz = new ExecuteBiz())
                {
                    svcRt = excBiz.ExecuteScalarQuery(strQuery, 15, null);
                }
                if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString;
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "GetTopGroup");
                strReturn = ex.Message;
            }
            return strReturn;
        }
        #endregion

        #region [코드테이블에서 필요한 코드들 가져오기]
        private string GetCodeDescription(JObject postData)
        {
            ServiceResult svcRt = new ServiceResult();
            StringBuilder sb = new StringBuilder();
            string strReturn = "";

            try
            {
                sb.Append("<div class=\"zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable modal-sm\">");
                sb.AppendFormat("<div class=\"modal-content\" data-for=\"{0}\" style=\"box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)\">", postData["k2"].ToString());
                sb.Append("<div class=\"modal-header\">");
                sb.Append("<h6 class=\"modal-title\"></h6>");
                sb.Append("<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>");
                //sb.AppendFormat("<input type=\"hidden\" data-for=\"param\" value=\"{0}\" />", postData["param"].ToString());
                sb.Append("</div>");
                sb.Append("<div class=\"modal-body\">"); //modal-body

                using (CommonBiz comBiz = new CommonBiz())
                {
                    svcRt = comBiz.SelectCodeDescription(postData["k1"].ToString(), postData["k2"].ToString(), postData["k3"].ToString());
                }

                if (svcRt.ResultCode == 0)
                {
                    if (svcRt.ResultItemCount > 0)
                    {
                        if (postData["k2"].ToString() == "currency" || postData["k2"].ToString() == "centercode" || postData["k2"].ToString() == "centercode2" || postData["k2"].ToString() == "chartcentercode" || postData["k2"].ToString() == "prodlawname")
                        {
                            //통화, 생산지표기
                            sb.Append("<table class=\"table table-striped table-sm mb-0\">");
                            if (postData["fn"].ToString() == "checkbox")
                            {
                                //복수선택
                                sb.Append("<colgroup><col width=\"5%\" /><col width=\"55%\" /><col width=\"40%\" /></colgroup>");
                                sb.Append("<tbody>");
                                foreach (DataRow row in svcRt.ResultDataSet.Tables[0].Rows)
                                {
                                    sb.Append("<tr>");
                                    sb.AppendFormat("<td><input type=\"checkbox\" name=\"ckbMultiOption\" value=\"{0}\" /></td>", row["item1"].ToString());
                                    sb.AppendFormat("<td>{0}</td>", row["item2"].ToString());
                                    sb.AppendFormat("<td>{0}</td>", row["item1"].ToString());
                                    sb.AppendFormat("</tr>");
                                }
                                if (postData["etc"].ToString() == "etc")
                                {
                                    sb.Append("<tr><td>기타</td><td><input type=\"checkbox\" name=\"ckbMultiOption\" value=\"\" /><td><input type=\"text\" class=\"z-input-in\" /></td></tr>");
                                }
                                sb.Append("</tbody>");
                            }
                            else
                            {
                                sb.Append("<colgroup><col width=\"60%\" /><col width=\"40%\" /></colgroup>");
                                sb.Append("<tbody>");
                                foreach (DataRow row in svcRt.ResultDataSet.Tables[0].Rows)
                                {
                                    sb.Append("<tr>");
                                    sb.AppendFormat("<td>{0}</td>", row["item2"].ToString());
                                    sb.AppendFormat("<td><a class=\"z-lnk-navy\" href=\"javascript:void(0)\" data-val=\"{0}\">{0}</a></td>", row["item1"].ToString());
                                    sb.AppendFormat("</tr>");
                                }
                                if (postData["etc"].ToString() == "etc")
                                {
                                    sb.Append("<tr><td>기타</td><td><input type=\"text\" class=\"form-control z-input-in\" /></td></tr>");
                                }
                                sb.Append("</tbody>");
                            }   
                            sb.Append("</table>");
                        }
                        else
                        {
                            sb.Append("<table class=\"table table-striped table-sm text-center mb-0\">");
                            sb.Append("<tbody>");
                            foreach (DataRow row in svcRt.ResultDataSet.Tables[0].Rows)
                            {
                                sb.AppendFormat("<tr><td><a class=\"z-lnk-navy\" href=\"javascript:void(0)\" data-val=\"{0}\">{0}</a></td></tr>", row["item1"].ToString());
                            }
                            if (postData["etc"].ToString() == "etc")
                            {
                                sb.Append("<tr><td><input type=\"text\" class=\"form-control z-input-in\" /></td></tr>");
                            }
                            sb.Append("</tbody>");
                            sb.Append("</table>");
                        }
                    }
                    else
                    {
                        sb.AppendFormat("<div class=\"text-center mt-3 h5 text-secondary\">{0}</div>", Resources.Global.NoItemShow);
                    }
                }
                else
                {
                    sb.AppendFormat("<div class=\"text-center mt-3 h5 text-secondary\">{0}</div>", svcRt.ResultMessage);
                }
                sb.Append("</div>");

                if (postData["fn"].ToString() == "checkbox")
                {
                    sb.Append("<div class=\"modal-footer\">"); //modal-footer
                    sb.Append("<button type=\"button\" class=\"btn btn-default btn-sm\" data-dismiss=\"modal\">닫기</button>");
                    sb.Append("<button type=\"button\" class=\"btn btn-primary btn-sm\" data-zm-menu=\"confirm\">확인</button>");
                    sb.Append("</div>");
                }

                sb.Append("</div>"); //content
                sb.Append("</div>");

                strReturn = "OK" + sb.ToString();
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "GetReportSearch");
                strReturn = "[" + strReturn + "] " + ex.Message;
            }
            finally
            {
            }
            return strReturn;
        }
        #endregion

        #region [집계/보고 관련 검색]
        private string GetReportSearch(JObject postData)
        {
            ServiceResult svcRt = new ServiceResult();
            StringBuilder sb = new StringBuilder();
            string strReturn = "";

            try
            {
                strReturn = "해당 조건이 누락됐습니다!";

                if (postData["k2"].ToString().IndexOf("ERP_") != -1)
                {
                    using (ReportBiz rptBiz = new ReportBiz())
                    {
                        svcRt = rptBiz.GetReportERP("", 0, postData["k2"].ToString(), "", "", postData["search"].ToString(), postData["v1"].ToString(), "", "", "");
                    }
                        
                    if (svcRt.ResultCode == 0)
                    {
                        if (!postData.ContainsKey("only"))
                        {
                            sb.Append("<div class=\"zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable modal-sm\">");
                            sb.AppendFormat("<div class=\"modal-content\" data-for=\"{0}\" style=\"box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)\">", postData["k2"].ToString());
                            sb.Append("<div class=\"modal-header\">");
                            sb.Append("<h6 class=\"modal-title\"></h6>");
                            sb.Append("<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>");
                            //sb.AppendFormat("<input type=\"hidden\" data-for=\"param\" value=\"{0}\" />", postData["param"].ToString());
                            sb.Append("</div>");
                            sb.Append("<div class=\"modal-body\">"); //modal-body
                        }
                        
                        if (svcRt.ResultItemCount > 0)
                        {
                            sb.Append("<table class=\"table table-striped table-sm text-center mb-0\">");
                            sb.Append("<colgroup><col width=\"45%\" /><col width=\"55%\" /></colgroup>");
                            sb.Append("<thead>");
                            sb.Append("<tr><th>코드</th><th>설명</th></tr>");
                            sb.Append("</thead>");
                            sb.Append("<tbody>");
                            foreach (DataRow row in svcRt.ResultDataSet.Tables[0].Rows)
                            {
                                sb.Append("<tr>");
                                sb.AppendFormat("<td><a class=\"z-lnk-navy\" href=\"javascript:void(0)\" data-val=\"{1}^{0}\">{0}</a></td>", row["ITEM1"].ToString(), row["ITEM2"].ToString());
                                sb.AppendFormat("<td>{0}</td>", row["ITEM2"].ToString());
                                sb.AppendFormat("</tr>");
                            }
                            sb.Append("</tbody>");
                            sb.Append("</table>");
                        }
                        else
                        {
                            sb.AppendFormat("<div class=\"text-center mt-3 h5 text-secondary\">{0}</div>", Resources.Global.NoItemShow);
                        }
                        
                        if (!postData.ContainsKey("only"))
                        {
                            sb.Append("</div>");

                            //sb.Append("<div class=\"modal-footer\">"); //modal-footer
                            //sb.Append("<button type=\"button\" class=\"btn btn-default btn-sm\" data-dismiss=\"modal\">닫기</button>");
                            //sb.Append("<button type=\"button\" class=\"btn btn-primary btn-sm\" data-zm-menu=\"confirm\">확인</button>");
                            //sb.Append("</div>");

                            sb.Append("</div>"); //content
                            sb.Append("</div>");
                        }   

                        strReturn = "OK" + sb.ToString();
                    }
                    else
                    {
                        strReturn = svcRt.ResultMessage;
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "GetReportSearch");
                strReturn = "[" + strReturn + "] " + ex.Message;
            }
            finally
            {
            }
            return strReturn;
        }
        #endregion
    }
}