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
                        //rt = GetCodeDescription(jPost);
                        ViewBag.JPost = jPost;
                        rt = RazorViewToString.RenderRazorViewToString(this, "_CodeDesc", ViewBag);
                        break;

                    case "getreportsearch":
                        //rt = GetReportSearch(jPost);
                        ViewBag.JPost = jPost;
                        rt = RazorViewToString.RenderRazorViewToString(this, "_ReportSearch", ViewBag);
                        break;

                    case "getoracleerp":
                        //rt = GetOracleERP(jPost);
                        ViewBag.JPost = jPost;
                        rt = RazorViewToString.RenderRazorViewToString(this, "_OracleERP", ViewBag);
                        break;

                    case "gettooling":
                        //rt = GetTooling(jPost);
                        ViewBag.JPost = jPost;
                        rt = RazorViewToString.RenderRazorViewToString(this, "_Tooling", ViewBag);
                        break;

                    case "getformchart":
                        //rt = GetFormChart(jPost);
                        ViewBag.JPost = jPost;
                        rt = RazorViewToString.RenderRazorViewToString(this, "_FormChart", ViewBag);
                        break;

                    case "checkexternalkey":
                        rt = CheckExternalKey(jPost);
                        break;

                    //case "searchworknoticepartinfo":
                    //    rt = SearchWorkNoticePartInfo(jPost);
                    //    break;

                    case "transferworknotice":
                        rt = TransferWorkNotice(jPost);
                        break;

                    default:
                        break;
                }
            }

            return rt.TrimStart();
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
                if (postData.ContainsKey("body") && postData["body"].ToString() != "N")
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

                if (postData.ContainsKey("body") && postData["body"].ToString() != "N")
                {
                    sb.Append("</div>"); //modal-body

                    if (postData["body"].ToString() == "F")
                    {
                        sb.Append("<div class=\"modal-footer\">"); //modal-footer
                        sb.Append("<button type=\"button\" class=\"btn btn-default btn-sm\" data-dismiss=\"modal\">닫기</button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-primary btn-sm\" data-zm-menu=\"confirm\">확인</button>");
                        sb.Append("</div>");
                    }

                    sb.Append("</div>"); //content
                    sb.Append("</div>");
                }   

                strReturn = "OK" + sb.ToString();
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "GetCodeDescription");
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
                if (postData.ContainsKey("body") && postData["body"].ToString() != "N")
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

                if (postData["k2"].ToString() == "FORM_VACATIONCHANGE")
                {
                    #region [사전휴가신청 목록]
                    using (ReportBiz rptBiz = new ReportBiz())
                    {
                        svcRt = rptBiz.GetReport("", Convert.ToInt32(postData["query"].ToString()), postData["k2"].ToString(), "", "", "", "", "", "", "");
                    }

                    if (svcRt.ResultCode == 0)
                    {
                        if (svcRt.ResultItemCount > 0)
                        {
                            sb.Append("<table class=\"table table-striped table-sm text-center mb-0\">");
                            Response.Write("<colgroup><col width=\"5%\" /><col width=\"20%\" /><col width=\"15%\" /><col width=\"15%\" /><col width=\"15%\" /><col width=\"30%\" /></colgroup>");
                            sb.Append("<thead>");
                            sb.Append("<tr><th></th><th>휴가일</th><th>휴가구분</th><th>시작시각</th><th>휴가갯수</th><th>등록일</th></tr>");
                            sb.Append("</thead>");
                            sb.Append("<tbody>");
                            foreach (DataRow row in svcRt.ResultDataSet.Tables[0].Rows)
                            {
                                sb.Append("<tr>");
                                sb.Append("<td>");
                                sb.Append("<input type=\"checkbox\" class=\"form-check-input\" />");
                                sb.AppendFormat("<input type=\"hidden\" data-for=\"TGID\" value=\"{0}\" />", row["ObjectID"].ToString());
                                sb.AppendFormat("<input type=\"hidden\" data-for=\"TGVACCLASS\" value=\"{0}\" />", row["LeaveClass"].ToString());
                                sb.AppendFormat("<input type=\"hidden\" data-for=\"TGMSG\" value=\"{0}\" />", row["RelatedMsg"].ToString());
                                sb.AppendFormat("<input type=\"hidden\" data-for=\"TGDATE\" value=\"{0}\" />", DateHelper.CheckDateTime(row["EventDate"].ToString()));
                                sb.Append("</td>");
                                sb.Append("</td>");
                                sb.AppendFormat("<td>{0}</td>", row["LeaveDate"].ToString());
                                sb.AppendFormat("<td>{0}</td>", row["LeaveDN"].ToString());
                                sb.AppendFormat("<td>{0}</td>", row["LeaveFromTime"].ToString());
                                sb.AppendFormat("<td>{0}</td>", row["LeaveCount"].ToString());
                                sb.AppendFormat("<td><a class=\"z-lnk-navy\" href=\"javascript:void(0)\" onclick=\"_zw.fn.openEAFormSimple('{0}')\">{1}</a></td>"
                                            , row["RelatedMsg"].ToString(), DateHelper.CheckDateTime(row["EventDate"].ToString()));
                                sb.AppendFormat("</tr>");
                            }
                            sb.Append("</tbody>");
                            sb.Append("</table>");
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
                    #endregion
                }
                else if (postData["k2"].ToString().IndexOf("ERP_") != -1)
                {
                    #region ["ERP_" 시작]
                    using (ReportBiz rptBiz = new ReportBiz())
                    {
                        svcRt = rptBiz.GetReportERP("", 0, postData["k2"].ToString(), "", "", postData["search"].ToString(), postData["v1"].ToString(), "", "", "");
                    }
                        
                    if (svcRt.ResultCode == 0)
                    {
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
                    }
                    else
                    {
                        sb.AppendFormat("<div class=\"text-center mt-3 h5 text-secondary\">{0}</div>", svcRt.ResultMessage);
                    }
                    #endregion
                }
                else
                {
                    strReturn = "해당 조건이 누락됐습니다!";
                }

                if (!postData.ContainsKey("only"))
                {
                    sb.Append("</div>");

                    if (postData["body"].ToString() == "F")
                    {
                        sb.Append("<div class=\"modal-footer\">"); //modal-footer
                        sb.Append("<button type=\"button\" class=\"btn btn-default btn-sm\" data-dismiss=\"modal\">닫기</button>");
                        sb.Append("<button type=\"button\" class=\"btn btn-primary btn-sm\" data-zm-menu=\"confirm\">확인</button>");
                        sb.Append("</div>");
                    }   

                    sb.Append("</div>"); //content
                    sb.Append("</div>");
                }
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

        #region [특정 외부키값을 가진 양식이 결재 진행중 또는 완료된 것이 있는지를 확인]
        /// <summary>
        /// 
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string CheckExternalKey(JObject postData)
        {
            string strReturn = "필수항목 누락!";
            if (!postData.ContainsKey("ft") || postData["fk"].ToString() == "") return strReturn;

            bool bPosible = false;

            try
            {
                using (BSL.FlowBiz.EApproval ea = new BSL.FlowBiz.EApproval())
                {
                    bPosible = ea.CheckExternalKeyPossible(postData["ft"].ToString(), postData["fk"].ToString());
                }
                if (bPosible) strReturn = "OKY";
                else strReturn = "OKN";
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "CheckExternalKey");
                strReturn = ex.Message;
            }

            return strReturn;
        }
        #endregion

        #region [나의 할일(work_notice) 관련]
        /// <summary>
        /// 나의 할일 이관
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string TransferWorkNotice(JObject postData)
        {
            string strReturn = "필수항목 누락!";
            if (!postData.ContainsKey("post") || postData["post"].ToString() == "" || !postData.ContainsKey("tgturid") || postData["tgturid"].ToString() == "") return strReturn;

            try
            {
                ServiceResult svcRt = new ServiceResult();
                using (BSL.InterfaceBiz.ReportBiz rptBiz = new BSL.InterfaceBiz.ReportBiz())
                {
                    svcRt = rptBiz.TransferWorkNotice(postData["post"].ToString(), postData["tgturid"].ToString()
                            , postData["tgtname"].ToString(), postData["tgtcode"].ToString(), postData["tgtmail"].ToString());
                }
                if (svcRt != null && svcRt.ResultCode == 0) strReturn = "OK";
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "TransferWorkNotice");
                strReturn = ex.Message;
            }

            return strReturn;
        }
        #endregion
    }
}