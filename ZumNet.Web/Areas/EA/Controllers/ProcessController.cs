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

using ZumNet.DAL.FlowDac;
using ZumNet.BSL.FlowBiz;
using ZumNet.Web.Bc;
using ZumNet.Web.Filter;

using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Flow;
using ZumNet.Framework.Exception;
using ZumNet.Framework.Util;
using static EcmaScript.NET.Node;

namespace ZumNet.Web.Areas.EA.Controllers
{
    public class ProcessController : Controller
    {
        #region [멤버변수]
        private string _mode = "";
        private string _processID = "";
        private string _formID = "";
        private string _oID = "";
        private string _workItemID = "";
        private string _msgID = "";
        private string _posID = "";
        private string _bizRole = "";
        private string _actRole = "";
        private string _externalKey1 = "";
        private string _externalKey2 = "";
        private string _xfAlias = String.Empty;    //2011-08-17 변경:결재양식외의 양식(금형대장 등)을 위해

        private string _signStatus = "";
        private string _requestDate = "";

        private string _workNotice = String.Empty;  //2011-08-09 추가(작업연결 정보)
        #endregion

        // GET: EA/Process
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

                AssignInitCondition(jPost);

                switch (this._mode)
                {
                    case "draft":
                        rt = DraftEAForm(jPost, "edit");
                        break;
                    case "newdraft":
                        rt = DraftEAForm(jPost, "new");
                        break;
                    case "approval":
                        rt = SingleApproval(jPost);
                        break;
                    case "reject":
                    case "back":
                        rt = DoReject(jPost);
                        break;
                    case "reserve":
                        rt = DoReserve(jPost);
                        break;
                    case "simpledraft"://2012-04-25
                        rt = SimpleDraft(jPost);
                        break;
                    case "simplework":
                        rt = SimpleApproval(jPost);
                        break;
                    case "preapproval": //2014-02-20 선결 처리
                        rt = PreApproval(jPost);
                        break;
                    case "canceldraft":
                        rt = CancelDraft(jPost);
                        break;
                    case "cancelservicequeue":
                        rt = CancelServiceQueue(jPost);
                        break;
                    case "chkpwd":
                        rt = CheckApprovalPassword(jPost);
                        break;
                    case "chkpwd2":
                        rt = CheckLogonPassword(jPost);
                        break;
                    //case "interface":
                    //    DoExtraWork(GetPostData());
                    //    break;
                    //case "savepersonline":
                    //    SavePersonLine(GetPostData());
                    //    break;
                    case "deletewithdraw":
                        rt = DeleteWithdraw(jPost);
                        break;
                    case "deletetemporary":
                        rt = DeleteTemporary(jPost);
                        break;
                    case "savetemporary":
                        rt = SaveTemporary(jPost, "edit");
                        break;
                    case "savenewtemporary":
                        rt = SaveTemporary(jPost, "new");
                        break;
                    case "newregisterformnotea":
                        rt = RegisterFormNotEA(jPost, "new");
                        break;
                    case "editregisterformnotea":
                        rt = RegisterFormNotEA(jPost, "edit");
                        break;
                    case "saveeditfield": //2014-07-16 양식 수정
                        rt = SaveEditField(jPost);
                        break;
                    default:
                        break;
                }
            }

            return rt;
        }

        #region [임시저장]
        /// <summary>
        /// 임시 저장 삭제
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string DeleteTemporary(JObject postData)
        {
            string strReturn = "";
            if (postData["tgt"].ToString() != "")
            {
                string strQuery = @"UPDATE admin.PH_XF_EA WITH (ROWLOCK) SET DeleteDate = GETDATE() WHERE MessageID IN (" + postData["tgt"].ToString() + ")";
                //ResponseText(strQuery); return; 

                ServiceResult svcRt = new ServiceResult();

                try
                {
                    using (ZumNet.BSL.InterfaceBiz.ExecuteBiz execBiz = new BSL.InterfaceBiz.ExecuteBiz())
                    {
                        svcRt = execBiz.ExecuteQueryTx(strQuery, 30, null);
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
                catch (Exception ex)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DeleteTemporary");
                    strReturn = ex.Message;
                }
            }
            return strReturn;
        }

        /// <summary>
        /// 임시저장
        /// </summary>
        /// <param name="postData"></param>
        /// <param name="command"></param>
        /// <returns></returns>
        private string SaveTemporary(JObject postData, string command)
        {
            JObject jBiz = null;
            JObject jMain = null;
            JObject jSub = null;
            JArray jFile = null;
            JArray jImg = null;

            XFormDefinition xfDef = null;

            string strTimeStamp = "";
            string strReturn = "";
            string strFileInfo = "";
            int iMessageID = 0;

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "[100]";
                jBiz = (JObject)postData["biz"];
                jMain = (JObject)postData["form"]["maintable"];
                jSub = (JObject)postData["form"]["subtables"];
                jFile = (JArray)postData["attachlist"];
                jImg = (JArray)postData["imglist"];

                if (jBiz["appid"].ToString() != "" && jBiz["appid"].ToString() != "0") iMessageID = Convert.ToInt32(jBiz["appid"].ToString());
                jBiz["docstatus"] = "000"; //상태값 저장

                strReturn = "[200]";

                strReturn = "[300]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(postData["dnid"].ToString()), jBiz["formid"].ToString());
                }

                if ((jFile != null && jFile.Count > 0) || (jImg != null && jImg.Count > 0))
                {
                    strReturn = "첨부 파일 처리";
                    //AttachInfo(cn, command, ref oFileInfo);
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), postData["xfalias"].ToString(), jFile, jImg
                                            , (jMain.ContainsKey("WEBEDITOR") ? jMain["WEBEDITOR"].ToString() : ""));
                    if (svcRt.ResultCode != 0)
                    {
                        throw new Exception(svcRt.ResultMessage);
                    }
                    else
                    {
                        jFile = (JArray)svcRt.ResultDataDetail["FileInfo"];
                        if (jImg != null && jImg.Count > 0)
                        {
                            postData["imglist"] = (JArray)svcRt.ResultDataDetail["ImgInfo"];
                            jMain["WEBEDITOR"] = svcRt.ResultDataDetail["Body"].ToString();
                        }
                    }
                    attachHdr = null;
                    //ResponseText(oFileInfo.OuterXml); return;

                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    foreach (JObject j in jFile)
                    {
                        if (j.ContainsKey("fld") && j["fld"].ToString() != "")
                        {
                            if (j["fld"].ToString().IndexOf(";") > 0)
                            {
                                //하위테이블 필드에서 찾기 : 필드명 + 하위테이블번호 + row 번호 (2015-03-26)
                                string[] vFld = j["fld"].ToString().Split(';');
                                if (jSub.ContainsKey("subtable" + vFld[1]))
                                {
                                    foreach (JObject o in jSub["subtable" + vFld[1]])
                                    {
                                        if (o["ROWSEQ"].ToString() == vFld[2])
                                        {
                                            o[vFld[0]] = j["filename"].ToString() + ";" + j["savedname"].ToString(); break;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //메인테이블 필드에서 찾기
                                if (jMain.ContainsKey(j["fld"].ToString())) jMain[j["fld"].ToString()] = j["filename"].ToString() + ";" + j["savedname"].ToString();

                            }
                        }
                    }
                }

                strReturn = "[600]"; //"양식 저장 및 프로세스 처리";
                using (EApproval ea = new EApproval())
                {
                    svcRt = ea.RegisterNewEA(Session["CompanyCode"].ToString(), command, _xfAlias, postData, xfDef, null, null, "", "", "", "");
                }

                if (svcRt.ResultCode == 0) strReturn = "OK";
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "SaveTemporary");
                strReturn = "ERROR :=> " + strReturn;// +Environment.NewLine + ex.Message;
            }
            finally
            {
                xfDef = null;
            }
            return strReturn;
        }
        #endregion

        #region [양식 수정]
        /// <summary>
        /// 
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string SaveEditField(JObject postData)
        {
            string strReturn = "현 작업 필수정보가 누락 되었습니다!";
            if (this._msgID == "" || this._formID == "") return strReturn;

            XFormDefinition xfDef = null;

            JObject jDoc = null;
            JObject jMain = null;
            JObject jSub = null;
            JArray jFile = null;
            JArray jImg = null;

            string strFileInfo = ""; //에디터 인라인이미지를 담기 위함

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "[100]";
                jDoc = (JObject)postData["doc"];
                jMain = (JObject)postData["form"]["maintable"];
                jSub = (JObject)postData["form"]["subtables"];
                jFile = (JArray)postData["attachlist"];
                jImg = (JArray)postData["imglist"];

                strReturn = "[300]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), this._formID);
                }

                if ((jFile != null && jFile.Count > 0) || (jImg != null && jImg.Count > 0))
                {
                    strReturn = "첨부 파일 처리";
                    //AttachInfo(cn, command, ref oFileInfo);
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), _xfAlias, jFile, jImg
                                            , (jMain.ContainsKey("WEBEDITOR") ? jMain["WEBEDITOR"].ToString() : ""));
                    if (svcRt.ResultCode != 0)
                    {
                        throw new Exception(svcRt.ResultMessage);
                    }
                    else
                    {
                        jFile = (JArray)svcRt.ResultDataDetail["FileInfo"];
                        if (jImg != null && jImg.Count > 0)
                        {
                            postData["imglist"] = (JArray)svcRt.ResultDataDetail["ImgInfo"];
                            jMain["WEBEDITOR"] = svcRt.ResultDataDetail["Body"].ToString();
                        }
                    }
                    attachHdr = null;
                    //ResponseText(oFileInfo.OuterXml); return;

                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    foreach (JObject j in jFile)
                    {
                        if (j.ContainsKey("fld") && j["fld"].ToString() != "")
                        {
                            if (j["fld"].ToString().IndexOf(";") > 0)
                            {
                                //하위테이블 필드에서 찾기 : 필드명 + 하위테이블번호 + row 번호 (2015-03-26)
                                string[] vFld = j["fld"].ToString().Split(';');
                                if (jSub.ContainsKey("subtable" + vFld[1]))
                                {
                                    foreach (JObject o in jSub["subtable" + vFld[1]])
                                    {
                                        if (o["ROWSEQ"].ToString() == vFld[2])
                                        {
                                            o[vFld[0]] = j["filename"].ToString() + ";" + j["savedname"].ToString(); break;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //메인테이블 필드에서 찾기
                                if (jMain.ContainsKey(j["fld"].ToString())) jMain[j["fld"].ToString()] = j["filename"].ToString() + ";" + j["savedname"].ToString();

                            }
                        }
                    }
                    if (jImg.Count > 0) foreach (JObject j in jImg) jFile.Add(j);
                }

                strReturn = "[600]"; //"양식 저장 및 프로세스 처리";
                string strActorKey = DateTime.Now.ToString("yyyyMMddHHmmssfff"); //2014-07-28
                using (WorkList workTx = new WorkList())
                {
                    svcRt = workTx.UpdateAppData(xfDef, jDoc, jMain, jSub, jFile, Convert.ToInt32(_msgID), _xfAlias
                                    , strActorKey, Session["URName"].ToString(), Convert.ToInt32(Session["URID"]), "");
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "SaveEditField");
                strReturn = "ERROR :=> " + strReturn;// +Environment.NewLine + ex.Message;
            }
            finally
            {
                xfDef = null;
            }
            return strReturn;
        }
        #endregion

        #region [기안처리]
        private string DraftEAForm(JObject postData, string command)
        {
            JObject jMain = null;
            JObject jSub = null;
            JObject jProcess = null;
            JArray jFile = null;
            JArray jImg = null;

            XFormDefinition xfDef = null;
            ProcessInstance pi = null;
            WorkItemList wiList = null;

            string strNow = "";
            string strPublishDate = "";
            string strAttInfo = "";
            //string strExtraInfo = "";
            string strTimeStamp = "";
            string strReturn = "";

            bool bSvcMode = false;      //2011-12-01 추가 : 서비스모드로 처리 여부
            int iSvcInterval = 10;      //2011-12-01 추가 : 서비스모드로 처리 시간 간격(기본 10분)

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "JSON 객체 할당";
                jMain = (JObject)postData["form"]["maintable"];
                jSub = (JObject)postData["form"]["subtables"];
                jProcess = (JObject)postData["process"];
                jFile = (JArray)postData["attachlist"];
                jImg = (JArray)postData["imglist"];

                strReturn = "처리요청일 설정"; //시간설정 - 등록일을 현재 시각과 비교해서 작으면 현재일로 등록
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                //2011-12-01 추가 : 서비스 모드 여부 및 간격 가져오기
                strReturn = "서비스모드";
                if (Session["FlowSvcMode"] != null)
                {
                    if (Session["FlowSvcMode"].ToString().Substring(0, 1) == "Y")  //전체 설정
                    {
                        bSvcMode = true;
                        iSvcInterval = Convert.ToInt32(Session["FlowSvcMode"].ToString().Substring(1));
                    }
                    else
                    {
                        bSvcMode = false;
                        iSvcInterval = 0;
                    }
                    if (iSvcInterval > 0)
                    {
                        strPublishDate = (Convert.ToDateTime(strPublishDate).AddMinutes((double)iSvcInterval)).ToString("yyyy-MM-dd HH:mm:ss");
                    }
                }

                if (_processID != "")
                {
                    strReturn = "프로세스 인스턴스 객체 할당";
                    pi = new ProcessInstance();
                    pi.DnID = Convert.ToInt16(postData["dnid"].ToString());
                    pi.ProcessID = Convert.ToInt16(_processID);
                    pi.SessionCode = "";
                    pi.XfAlias = _xfAlias;
                    //pi.Name = oBizInfo.SelectSingleNode("name").InnerText;//strProcessName;
                    pi.Priority = 0;
                    pi.Permission = "";
                    pi.Creator = postData["creator"]["user"].ToString();
                    pi.CreatorID = Convert.ToInt32(postData["creator"]["urid"].ToString());
                    pi.CreatorCN = postData["creator"]["urcn"].ToString();
                    pi.CreatorGrade = postData["creator"]["grade"].ToString();
                    pi.CreatorDept = postData["creator"]["dept"].ToString();
                    pi.CreatorDeptID = Convert.ToInt32(postData["creator"]["deptid"].ToString());
                    pi.CreatorDeptCode = postData["creator"]["deptcd"].ToString();
                    pi.Started = strPublishDate;
                    pi.ExpectedEnd = "";

                    //Response.Write(" 여기 => " + oProcessInfo["signline"].OuterXml.ToString()); return;

                    strReturn = "초기 참여자 정보 생성";
                    wiList = WorkListHelper.ConvertJsonLineToWorkItemList(0, (JArray)jProcess["signline"]);

                    strReturn = "기안자 사인 할당";//선도에서 우선 사용
                    foreach (WorkItem wi in wiList)
                    {
                        if (wi.BizRole == "normal" && wi.ActRole == "_drafter")
                        {
                            wi.Signature = SignImg(Session["CompanyCode"].ToString(), pi.CreatorCN);
                            //if (postData.ContainsKey("cmnt")) wi.Comment = postData["cmnt"].ToString();
                            //ResponseText("::::: 여기 : " + wi.Signature); return;
                            break;
                        }
                    }

                    strReturn = "인스턴스 속성 정보 할당";
                    if (jProcess["attributes"] != null)
                    {
                        //2011-03-22 배포목록 경우 wid 값 설정, 2020-07-02 xform_cf 추가
                        foreach (JObject j in jProcess["attributes"])
                        {
                            if (j["att"].ToString() == "mail_dl" || j["att"].ToString() == "xform_dl" || j["att"].ToString() == "xform_cf")
                            {
                                if (j["actid"].ToString() == "") j["actid"] = wiList.Items[0].WorkItemID;
                            }
                        }
                        strAttInfo = WorkListHelper.JsonToXmlAttributes((JArray)jProcess["attributes"]);

                        //XmlDocument xmlAttr = new XmlDocument();
                        //xmlAttr.LoadXml(strAttInfo);
                        //foreach (XmlNode att in xmlAttr.SelectNodes("//attribute"))
                        //{
                        //    if (att.Attributes["att"].Value == "xform_dl")
                        //    {
                        //        ResponseText(Environment.NewLine + "--@@@ xform_dl : " + att.Attributes["actid"].Value + " ::: " + att.SelectSingleNode("display").InnerText + " ::: " + att.SelectSingleNode("value").InnerText);
                        //    }
                        //    else
                        //    {
                        //        ResponseText(Environment.NewLine + "--@@@ else : " + att.Attributes["actid"].Value + " : " + att.SelectSingleNode("value").InnerText);
                        //    }

                        //}
                        //return;
                    }
                }

                //strReturn = "외부연동 값 설정";
                //switch (oBizInfo.Attributes["formid"].Value)
                //{
                //    case "EE2BC5ED4F8A4C789D4673466BB21DB7"://외주공사
                //        strExtraInfo = "<docinfo><field seq=\"0\">" + strPublishDate + "</field></docinfo>";
                //        break;
                //    default:
                //        break;
                //}

                strReturn = "데이타베이스 연결";
                //cn = new SqlConnection(RegistryHandler.GetConnectionStringASP(Session["CompanyCode"].ToString(), (RegistryHandler.INITIAL_CATALOG.INIT_CAT_EKP)));

                strReturn = "양식정의 객체 생성";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(postData["dnid"].ToString()), postData["biz"]["formid"].ToString());
                }

                if (pi != null)
                {
                    strReturn = "프로세스명 구성";
                    //def->APPLICANT,V_KIND,V_FROM~V_TO
                    if (xfDef.ProcessNameString != "")
                    {
                        char cDiv = (char)8;
                        char cDel = (char)7; //하위테이블 필드가 있는 경우
                        string[] vProcName = xfDef.ProcessNameString.Split(cDiv);
                        string[] vSub = null;

                        string strValue = "";

                        for (int i = 0; i < vProcName.Length; i++)
                        {
                            if (vProcName[i].IndexOf(cDel) < 0)
                            {
                                strValue = ConvertCommonFieldToNodeValue(postData, vProcName[i], strPublishDate);
                                if (strValue != "?")
                                {
                                    //common field 내용에 대해서 구성
                                    pi.Name += strValue;
                                }
                                else
                                {
                                    //노드 구성에 부적합한 이름이 들어오는 경우를 대비
                                    try
                                    {
                                        if (jMain.ContainsKey(vProcName[i]))
                                            pi.Name += jMain[vProcName[i]].ToString();
                                        else
                                            pi.Name += vProcName[i];
                                    }
                                    catch { pi.Name += vProcName[i]; }
                                }
                            }
                            else
                            {
                                //2011-12-22 추가(하위테이블 경우 - 첫번째 row에 대해서만)
                                vSub = vProcName[i].Split(cDel);
                                try
                                {
                                    if (jSub.ContainsKey("subtable" + vSub[0].Substring(1)))
                                    {
                                        JObject j = (JObject)jSub["subtable" + vSub[0].Substring(1)][0];
                                        if (j.ContainsKey(vSub[1])) pi.Name += j[vSub[1]].ToString();
                                        else pi.Name += vSub[1];
                                    }
                                    else pi.Name += vSub[1];
                                }
                                catch { pi.Name += vSub[1]; }
                            }
                            //ResponseText(" ** 여기 : " + i.ToString() + " => " + vProcName[i]);  
                        }
                    }

                    if (pi.Name == null || pi.Name == "") pi.Name = postData["biz"]["piname"].ToString();
                    if (postData["doc"]["subject"] != null && postData["doc"]["subject"].ToString() == "") postData["doc"]["subject"] = pi.Name;
                }
                //ResponseText("제목=>" + pi.Name); return;

                //string strFileInfo = "";
                if ((jFile != null && jFile.Count > 0) || (jImg != null && jImg.Count > 0))
                {
                    strReturn = "첨부 파일 처리";
                    //AttachInfo(cn, command, ref oFileInfo);
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), _xfAlias, jFile, jImg
                                            , (jMain.ContainsKey("WEBEDITOR") ? jMain["WEBEDITOR"].ToString() : ""));
                    if (svcRt.ResultCode != 0)
                    {
                        throw new Exception(svcRt.ResultMessage);
                    }
                    else
                    {
                        jFile = (JArray)svcRt.ResultDataDetail["FileInfo"];
                        if (jImg != null && jImg.Count > 0)
                        {
                            postData["imglist"] = (JArray)svcRt.ResultDataDetail["ImgInfo"];
                            jMain["WEBEDITOR"] = svcRt.ResultDataDetail["Body"].ToString();
                        }
                    }
                    attachHdr = null;
                    //ResponseText(oFileInfo.OuterXml); return;

                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    foreach (JObject j in jFile)
                    {
                        if (j.ContainsKey("fld") && j["fld"].ToString() != "")
                        {
                            if (j["fld"].ToString().IndexOf(";") > 0)
                            {
                                //하위테이블 필드에서 찾기 : 필드명 + 하위테이블번호 + row 번호 (2015-03-26)
                                string[] vFld = j["fld"].ToString().Split(';');
                                if (jSub.ContainsKey("subtable" + vFld[1]))
                                {
                                    foreach(JObject o in jSub["subtable" + vFld[1]])
                                    {
                                        if (o["ROWSEQ"].ToString() == vFld[2])
                                        {
                                            o[vFld[0]] = j["filename"].ToString() + ";" + j["savedname"].ToString(); break;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //메인테이블 필드에서 찾기
                                if (jMain.ContainsKey(j["fld"].ToString())) jMain[j["fld"].ToString()] = j["filename"].ToString() + ";" + j["savedname"].ToString();

                            }
                        }
                    }
                }
                //strFileInfo = "";
                
                //return JsonConvert.SerializeObject(postData);
                //ResponseText(" * string->" + oFileInfo.SelectNodes("file[@isfile='Y']").Count.ToString());
                //return;
                if (bSvcMode)
                {
                    strReturn = "서비스 처리"; //양식 저장 후 서비스 처리
                    postData["biz"]["docstatus"] = "010"; //양식 상태값 저장(대기)

                    string strFormSchema = Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                    string strFormPath = Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                    using (EApproval ea = new EApproval())
                    {
                        svcRt = ea.DraftService(command, _xfAlias, postData, xfDef, pi, wiList, strPublishDate, strAttInfo, strFormSchema, strFormPath
                                , Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptAlias"].ToString()
                                , Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString());
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;

                    //양식 저장 없이 서비스 처리
                    //int iMessageID = (oBizInfo.Attributes["msgid"].Value != "" && oBizInfo.Attributes["msgid"].Value != "0") ? Convert.ToInt32(oBizInfo.Attributes["msgid"].Value) : 0;

                    //string strFormSchema = Server.MapPath("/" + Application["rootFolderName"].ToString() + "/EA/Controls/ph_xform_ea.xml");
                    //string strFormPath = Server.MapPath("/" + Application["rootFolderName"].ToString() + "/EA/Forms/");// + Session["DNAlias"].ToString());

                    //using (Phs.BFF.Process.EngineTx engineTx = new Phs.BFF.Process.EngineTx())
                    //{
                    //    strReturn = engineTx.SendBFFServiceQueue(cn, wiList, null, null, Environment.MachineName, Convert.ToInt32(Session["DNID"]), Session["CompanyCode"].ToString()
                    //                                , (int)ProcessStateChart.BFFServiceState.Pending, 0, strPublishDate, _xfAlias, iMessageID.ToString(), xfDef.FormID, "", "", 100
                    //                                , "", Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptAlias"].ToString()
                    //                                , Session["SubDomainName"].ToString(), Application["rootFolderName"].ToString(), strFormSchema, strFormPath, xmlDoc.OuterXml, ""
                    //                                , strAttInfo, pi.Name, "", "", "");
                    //}

                }
                else
                {
                    strReturn = "양식 저장 및 프로세스 처리";
                    using (EApproval ea = new EApproval())
                    {
                        svcRt = ea.RegisterNewEA(Session["CompanyCode"].ToString(), command, _xfAlias, postData, xfDef, pi, wiList, strPublishDate, strAttInfo
                                                , Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString());
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString + (char)8 + strPublishDate;
                    else strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DraftEAForm");
                strReturn = "[ERROR]기안 처리 중 오류 발생!" + Environment.NewLine + strReturn;// +Environment.NewLine + ex.Message;
            }
            finally
            {
                jMain = null;
                jSub = null;
                jProcess = null;
                jFile = null;

                xfDef = null;
                pi = null;
                wiList = null;

                svcRt = null;
            }
            return strReturn;
        }
        #endregion

        #region [일괄/단순 기안]
        private string SimpleDraft(JObject postData)
        {
            //formid, 
            string strReturn = "양식정보가 누락 되었습니다!";
            _formID = postData["fi"].ToString();
            if (postData["fi"].ToString() == "") return strReturn;

            strReturn = "필수항목이 누락 되었습니다!";
            if (postData["k1"].ToString() == "" || postData["k2"].ToString() == "" || postData["k3"].ToString() == "") return strReturn;

            EApprovalDac eaDac = null;

            XFormDefinition xfDef = null;
            ProcessInstance pi = null;
            SchemaList schemaActList = null;
            WorkItemList wiList = null;

            JObject jForm = null;
            JObject jBiz = null;
            JObject jDoc = null;
            JObject jMain = null;
            JObject jSub = null;
            JObject jProcess = null;
            JObject jCreator = null;

            DataSet dsFormData = null;
            string[] vEdmInfo = null;
            string strConnect = "";
            string strFormDB = "";
            string strNow = "";
            string strPublishDate = "";
            string strTimeStamp = "";

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "데이타베이스 연결";
                strFormDB = Framework.Configuration.ConfigINI.GetValue(Framework.Configuration.Sections.SECTION_DBNAME, Framework.Configuration.Property.INIKEY_DB_FORM);

                eaDac = new EApprovalDac();
                xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), _formID);
                if (xfDef == null) strReturn = "해당 양식 정보를 가져오지 못했습니다!";

                using (WorkList workList = new WorkList())
                {
                    schemaActList = workList.RetrieveSchemaList(xfDef.ProcessID, 0, 0, "", "", _formID + ";" + Session["DeptID"].ToString());
                }
                if (schemaActList == null)strReturn = "해당 프로세스 스키마를 가져오지 못했습니다!";

                strReturn = "생성할 양식 정보 불러오기!";
                dsFormData = eaDac.SelectFormDataForDraft(strFormDB, xfDef.MainTable, xfDef.Version, xfDef.SubTableCount, postData["k1"].ToString(), postData["k2"].ToString(), postData["k3"].ToString(), "", "");

                //Response.Write(" 양식 => " + xfDef.MainTable + " : " + postData["k1"].ToString() + " :" + postData["k2"].ToString() + " : " + postData["k3"].ToString()); return;

                //strReturn = "사업장 정보 가져오기";
                //rowCorp = EApproval.RetrieveCorpInfo(cn, Convert.ToInt32(Session["OPGroupID"]));
                vEdmInfo = xfDef.Reserved2.Split(';');
                //ResponseText(vEdmInfo[1] + " : " + vEdmInfo[3]); Response.End();

                strReturn = "JSON 객체 생성";
                using (StreamReader reader = System.IO.File.OpenText(Server.MapPath("~/Content/Json/jform_ea_post.json")))
                {
                    jForm = (JObject)JToken.ReadFrom(new JsonTextReader(reader));
                }

                jBiz = (JObject)jForm["biz"];
                jDoc = (JObject)jForm["doc"];
                //jMain = (JObject)jForm["form"]["maintable"];
                //jSub = (JObject)jForm["form"]["subtables"];
                jProcess = (JObject)jForm["process"];
                jCreator = (JObject)jForm["creator"];

                strReturn = "XML 값 할당 - 키정보";
                jBiz["dnid"] = Session["DNID"].ToString();
                jBiz["processid"] = xfDef.ProcessID.ToString();
                jBiz["formid"] = xfDef.FormID;
                jBiz["ver"] = xfDef.Version.ToString();
                jBiz["inherited"] = (vEdmInfo.Length > 1) ? vEdmInfo[1] : "G"; //2015-06-10 inherited, priority, secret 설정 추가
                jBiz["priority"] = "N";
                jBiz["secret"] = "N";
                jBiz["doclevel"] = vEdmInfo[3]; //24-02-15 추가
                jBiz["keepyear"] = vEdmInfo[2]; //24-02-15 추가

                strReturn = "XML 값 할당 - 작성자";
                jCreator["user"] = Session["URName"].ToString();
                jCreator["empno"] = Session["empid"].ToString();
                jCreator["grade"] = Session["GRADE1"].ToString();
                jCreator["dept"] = Session["DeptName"].ToString();
                jCreator["urid"] = Session["URID"].ToString();
                jCreator["urcn"] = Session["LogonID"].ToString();
                jCreator["deptid"] = Session["DeptID"].ToString();
                jCreator["deptcd"] = Session["DeptAlias"].ToString();
                jCreator["belong"] = Session["Belong"].ToString();
                jCreator["indate"] = Session["InDate"].ToString();

                strReturn = "XML 값 할당 - 공통정보";
                jDoc["credate"] = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
                jDoc["docname"] = xfDef.DocName;
                jDoc["doclevel"] = vEdmInfo[3];
                jDoc["keepyear"] = vEdmInfo[2];
                jDoc["subject"] = "";
                jDoc["key1"] = "";
                jDoc["key2"] = "";

                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = "";
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                strReturn = "본문 구성";
                jForm["form"] = ComposeFormData(xfDef.MainTable, dsFormData, ref jDoc);
                jMain = (JObject)jForm["form"]["maintable"]; //24-02-15 위에서 여기로
                jSub = (JObject)jForm["form"]["subtables"];

                //Response.Write(" 여기 => " + oFormInfo.InnerXml.ToString()); return;

                strReturn = "프로세스 인스턴스 객체 할당";
                pi = new ProcessInstance();
                pi.DnID = Convert.ToInt16(jBiz["dnid"].ToString());
                pi.ProcessID = xfDef.ProcessID;
                pi.SessionCode = "";
                pi.XfAlias = _xfAlias;
                pi.Priority = 0;
                pi.Permission = "";
                pi.Creator = jCreator["user"].ToString();
                pi.CreatorID = Convert.ToInt32(jCreator["urid"].ToString());
                pi.CreatorCN = jCreator["urcn"].ToString();
                pi.CreatorGrade = jCreator["grade"].ToString();
                pi.CreatorDept = jCreator["dept"].ToString();
                pi.CreatorDeptID = Convert.ToInt32(jCreator["deptid"].ToString());
                pi.CreatorDeptCode = jCreator["deptcd"].ToString();
                pi.Started = strPublishDate;
                pi.ExpectedEnd = "";

                strReturn = "초기 참여자 정보 생성";
                wiList = ComposeWorkList(schemaActList, jCreator, dsFormData);
                //Response.Write(" 여기 => " + oProcessInfo["signline"].OuterXml.ToString()); return;

                strReturn = "기안자 사인 할당";//선도에서 우선 사용
                foreach (WorkItem wi in wiList)
                {
                    if (wi.BizRole == "normal" && wi.ActRole == "_drafter")
                    {
                        wi.Signature = SignImg(Session["CompanyCode"].ToString(), pi.CreatorCN);
                        break;
                    }
                }

                if (pi != null)
                {
                    strReturn = "프로세스명 구성";
                    if (xfDef.ProcessNameString != "")
                    {
                        char cDiv = (char)8;
                        char cDel = (char)7; //하위테이블 필드가 있는 경우
                        string[] vProcName = xfDef.ProcessNameString.Split(cDiv);
                        string[] vSub = null;

                        string strValue = "";

                        for (int i = 0; i < vProcName.Length; i++)
                        {
                            if (vProcName[i].IndexOf(cDel) < 0)
                            {
                                strValue = ConvertCommonFieldToNodeValue(jForm, vProcName[i], strPublishDate);
                                if (strValue != "?")
                                {
                                    pi.Name += strValue;
                                }
                                else
                                {
                                    try
                                    {
                                        if (jMain.ContainsKey(vProcName[i]))
                                            pi.Name += jMain[vProcName[i]].ToString();
                                        else
                                            pi.Name += vProcName[i];
                                    }
                                    catch { pi.Name += vProcName[i]; }
                                }
                            }
                            else
                            {
                                //2011-12-22 추가(하위테이블 경우 - 첫번째 row에 대해서만)
                                vSub = vProcName[i].Split(cDel);
                                try
                                {
                                    if (jSub.ContainsKey("subtable" + vSub[0].Substring(1)))
                                    {
                                        JObject j = (JObject)jSub["subtable" + vSub[0].Substring(1)][0];
                                        if (j.ContainsKey(vSub[1])) pi.Name += j[vSub[1]].ToString();
                                        else pi.Name += vSub[1];
                                    }
                                    else pi.Name += vSub[1];
                                }
                                catch { pi.Name += vSub[1]; }
                            }
                            //ResponseText(" ** 여기 : " + i.ToString() + " => " + vProcName[i]);  
                        }
                    }

                    if (pi.Name == null || pi.Name == "") pi.Name = jBiz["piname"].ToString();
                    if (jDoc.ContainsKey("subject") && jDoc["subject"].ToString() == "") jDoc["subject"] = pi.Name;
                }
                //Response.Write(" 여기 => " + xmlDoc.InnerXml.ToString()); return;

                strReturn = "양식 저장 및 프로세스 처리";
                using (EApproval ea = new EApproval())
                {
                    svcRt = ea.RegisterNewEA(Session["CompanyCode"].ToString(), "NEW", _xfAlias, jForm, xfDef, pi, wiList, strPublishDate, ""
                                            , Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString());
                }
                if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString + (char)8 + strPublishDate;
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "SimpleDraft");
                strReturn = "[ERROR]결재 처리 중 오류 발생!" + Environment.NewLine + strReturn;
            }
            finally
            {
                if (dsFormData != null) { dsFormData.Dispose(); dsFormData = null; }

                xfDef = null;
                pi = null;
                schemaActList = null;
                wiList = null;
            }

            return strReturn;
        }

        /// <summary>
        /// 양식별 자동기안시 구성되는 양식데이타
        /// </summary>
        /// <param name="formTable"></param>
        /// <param name="formData"></param>
        /// <param name="docInfo"></param>
        /// <returns></returns>
        private JObject ComposeFormData(string formTable, DataSet formData, ref JObject docInfo)
        {
            DataRow row = null;
            JObject jForm = JObject.Parse("{}");
            JObject j = JObject.Parse("{}");
            if (formData != null && formData.Tables.Count > 0)
            {
                if (formTable == "FORM_MONEYCONTRACT" || formTable == "FORM_MONEYCONTRACT2" || formTable == "FORM_MONEYCONTRACT3")
                {
                    if (formData.Tables[0].Rows.Count > 0)
                    {
                        row = formData.Tables[0].Rows[0];
                        j["LOGOPATH"] = "/Storage/cresyn/CI/cresynin_logo_small.gif";  //로고
                        j["THENAME"] = row["UserDN"].ToString();    //계약자
                        j["THEID"] = row["UserID"].ToString();        //계약자ID
                        j["THEEMPID"] = row["EmpID"].ToString();  //계약자사번
                        j["THEGRADE"] = row["UserGrade"].ToString();  //계약자직급
                        j["THEDEPT"] = row["OrgInfo"].ToString();    //계약자부서
                        j["THEDEPTID"] = row["DeptID"].ToString();//계약자부서ID
                        j["FROMYEAR"] = row["FromYear"].ToString();  //시작년
                        j["FROMMONTH"] = row["FromMonth"].ToString();//시작월
                        j["FROMDAY"] = row["FromDay"].ToString();    //시작일
                        j["TOYEAR"] = row["ToYear"].ToString();      //종료년
                        j["TOMONTH"] = row["ToMonth"].ToString();    //종료월
                        j["TODAY"] = row["ToDay"].ToString();        //종료일
                        j["DURING"] = row["PayMonth"].ToString();      //계약기간
                        j["TOTMONEY"] = row["PayA"].ToString();  //총연봉
                        j["PERMONEY"] = row["PayB"].ToString();  //분활연봉
                        j["STDMONEY"] = row["PayC"].ToString();  //기본급
                        j["DLYTIME"] = row["PayTime"].ToString();    //연장근로시간
                        j["DLYMONEY"] = row["PayD"].ToString();  //연장근로수당
                        j["OTHERMONEY"] = row["PayE"].ToString();  //기타수당(직급, 자동화설계 수당)
                        j["CTRYEAR"] = row["ContractYear"].ToString();    //계약년
                        j["CTRMONTH"] = row["ContractMonth"].ToString();  //계약월
                        j["CTRDAY"] = row["ContractDay"].ToString();      //계약일

                        docInfo["key1"] = row["FromYear"].ToString() + "-" + row["SalaryType"].ToString() + "-" + row["UserID"].ToString();
                    }
                    jForm["maintable"] = j;
                    jForm["subtables"] = JObject.Parse("{}");
                }
                else if (formTable == "FORM_ETHICALMANAGEMENT")
                {
                    if (formData.Tables[0].Rows.Count > 0)
                    {
                        row = formData.Tables[0].Rows[0];
                        j["LOGOPATH"] = "/Storage/cresyn/CI/cresynin_logo_small.gif";  //로고
                        j["THENAME"] = row["UserDN"].ToString();    //서약자
                        j["THEID"] = row["UserID"].ToString();        //서약자ID
                        j["THEEMPID"] = row["EmpID"].ToString();  //서약자사번
                        j["THEGRADE"] = row["UserGrade"].ToString();  //서약자직급
                        j["THEDEPT"] = row["OrgInfo"].ToString();    //서약자부서
                        j["THEDEPTID"] = row["DeptID"].ToString();//서약자부서ID
                        j["CTRYEAR"] = row["NowYear"].ToString();    //서약년
                        j["CTRMONTH"] = row["NowMonth"].ToString();  //서약월
                        j["CTRDAY"] = row["NowDay"].ToString();      //계약일

                        docInfo["key1"] = row["NowYear"].ToString() + "-" + row["UserID"].ToString();
                    }
                    jForm["maintable"] = j;
                    jForm["subtables"] = JObject.Parse("{}");
                }
                else if (formTable == "FORM_GONGDONGGONGGA")
                {
                    if (formData.Tables[0].Rows.Count > 0)
                    {
                        row = formData.Tables[0].Rows[0];
                        j["LOGOPATH"] = "/Storage/cresyn/CI/cresynin_logo_small.gif";  //로고
                        j["STDDATE1"] = row["StdDate1"].ToString();    //연차1
                        j["STDTYPE1"] = row["StdType1"].ToString();    //타입1
                        j["STDDATE2"] = row["StdDate2"].ToString();    //연차2
                        j["STDTYPE2"] = row["StdType2"].ToString();    //타입2
                        j["STDDATE3"] = row["StdDate3"].ToString();    //연차3
                        j["STDTYPE3"] = row["StdType3"].ToString();    //타입3
                        j["STDDATE4"] = row["StdDate4"].ToString();    //연차4
                        j["STDTYPE4"] = row["StdType4"].ToString();    //타입4
                        j["STDDATE5"] = row["StdDate5"].ToString();    //연차5
                        j["STDTYPE5"] = row["StdType5"].ToString();    //타입5
                        j["STDDAY"] = row["StdDay"].ToString();    //일수
                        j["THENAME"] = row["UserDN"].ToString();    //서약자
                        j["THEID"] = row["UserID"].ToString();        //서약자ID
                        j["THEEMPID"] = row["EmpID"].ToString();  //서약자사번
                        j["THEGRADE"] = row["UserGrade"].ToString();  //서약자직급
                        j["THEDEPT"] = row["OrgInfo"].ToString();    //서약자부서
                        j["THEDEPTID"] = row["DeptID"].ToString();//서약자부서ID
                        j["CTRYEAR"] = row["NowYear"].ToString();    //서약년
                        j["CTRMONTH"] = row["NowMonth"].ToString();  //서약월
                        j["CTRDAY"] = row["NowDay"].ToString();      //계약일

                        docInfo["key1"] = row["StdDate1"].ToString() + "-" + row["UserID"].ToString();
                    }
                    jForm["maintable"] = j;
                    jForm["subtables"] = JObject.Parse("{}");
                }
            }

            row = null;
            return jForm;
        }

        /// <summary>
        /// 자동기안에 쓰이는 결재선 구성
        /// </summary>
        /// <param name="scmList"></param>
        /// <param name="ceatorInfo"></param>
        /// <param name="formData"></param>
        /// <returns></returns>
        private WorkItemList ComposeWorkList(SchemaList scmList, JObject ceatorInfo, DataSet formData)
        {
            WorkItemList wiList = new WorkItemList();
            WorkItem wi = null;
            int iStep = 1;

            foreach (Schema item in scmList)
            {
                if (item.ActRole == "_drafter")
                {
                    wi = new WorkItem();
                    wi.Mode = ProcessStateChart.SignLineModification.Insert;
                    wi.PartType = item.PartType;
                    wi.ParticipantID = ceatorInfo["urid"].ToString();
                    wi.WorkItemID = ProcessStateChart.NewGuid();
                    wi.OID = 0;
                    wi.ParentWorkItemID = "";
                    wi.Step = iStep;
                    wi.SubStep = 0;
                    wi.Seq = 0;
                    wi.State = (int)ProcessStateChart.WorkItemState.InActive;
                    wi.SignStatus = (int)ProcessStateChart.SignStatus.None;
                    wi.SignKind = (int)ProcessStateChart.SignKind.Normal;
                    wi.ViewState = (int)ProcessStateChart.WorkItemViewState.InProgress;
                    wi.Flag = "";
                    wi.Designator = "";
                    wi.ActivityID = item.ActivityID;
                    wi.BizRole = item.BizRole;
                    wi.ActRole = item.ActRole;
                    wi.Limited = "";
                    wi.ReceivedDate = "";
                    wi.CompletedDate = "";
                    wi.CompetencyCode = 0;
                    wi.Signature = "";
                    wi.Comment = "";
                    wi.ParticipantName = ceatorInfo["user"].ToString();
                    wi.ParticipantDeptCode = ceatorInfo["deptcd"].ToString();
                    wi.Reserved1 = "";
                    wi.Reserved2 = "";

                    wiList.Add(wi);
                    iStep++;
                }
                else
                {
                    if (item.PartType == "u_b__")
                    {
                        wi = new WorkItem();
                        wi.Mode = ProcessStateChart.SignLineModification.Insert;
                        wi.PartType = item.PartType;
                        wi.ParticipantID = formData.Tables[0].Rows[0]["UserID"].ToString();
                        wi.WorkItemID = ProcessStateChart.NewGuid();
                        wi.OID = 0;
                        wi.ParentWorkItemID = "";
                        wi.Step = iStep;
                        wi.SubStep = 0;
                        wi.Seq = 0;
                        wi.State = (int)ProcessStateChart.WorkItemState.InActive;
                        wi.SignStatus = (int)ProcessStateChart.SignStatus.None;
                        wi.SignKind = (int)ProcessStateChart.SignKind.Normal;
                        wi.ViewState = (int)ProcessStateChart.WorkItemViewState.InProgress;
                        wi.Flag = "";
                        wi.Designator = "";
                        wi.ActivityID = item.ActivityID;
                        wi.BizRole = item.BizRole;
                        wi.ActRole = item.ActRole;
                        wi.Limited = "";
                        wi.ReceivedDate = "";
                        wi.CompletedDate = "";
                        wi.CompetencyCode = 0;
                        wi.Signature = "";
                        wi.Comment = "";
                        wi.ParticipantName = formData.Tables[0].Rows[0]["UserDN"].ToString();
                        wi.ParticipantDeptCode = "";
                        wi.Reserved1 = "";
                        wi.Reserved2 = "";

                        wiList.Add(wi);
                        break;
                    }
                }
            }
            return wiList;
        }
        #endregion

        #region [단일 결재]
        private string SingleApproval(JObject postData)
        {
            string strReturn = "현 결재작업 필수정보가 누락 되었습니다!";
            if (this._processID == "" || this._workItemID == "") return strReturn;

            strReturn = "결재상태값이 없습니다!";
            if (this._signStatus == "") return strReturn;

            JObject jBiz = null;
            JObject jDoc = null;
            JObject jProcess = null;
            JObject jMain = null;
            JObject jSub = null;
            JArray jFile = null;
            JArray jImg = null;

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            ProcessInstance pi = null;
            Activity curActivity = null;
            WorkItemList paramWiList = null;
            WorkItemList originWiList = null;
            WorkItem curWI = null;

            string strNow = "";
            string strPublishDate = "";
            string strDeleteLine = "";
            string strFormInfo = "";
            string strFileInfo = "";
            string strAttInfo = "";
            //string strExtraInfo = "";
            string strTimeStamp = "";

            bool bNotice = false;
            bool bSvcMode = false;      //2011-06-29 추가 : 서비스모드로 처리 여부
            int iSvcInterval = 10;      //2011-06-29 추가 : 서비스모드로 처리 시간 간격(기본 10분)

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "JSON 객체 할당";  //strReturn = "XML 객체 생성";

                jBiz = (JObject)postData["biz"];
                jDoc = (JObject)postData["doc"];
                jProcess = (JObject)postData["process"];
                jMain = (JObject)postData["form"]["maintable"];
                jSub = (JObject)postData["form"]["subtables"];
                jFile = (JArray)postData["attachlist"];
                jImg = (JArray)postData["imglist"];

                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    curWI = procDac.SelectWorkItem(this._workItemID);

                    if ((curWI.PartType.Substring(0, 1) == "u") && (curWI.ParticipantID != Session["URID"].ToString()))
                    {
                        strReturn = "현 결재자와 접속자 정보가 틀립니다!";
                        return strReturn;
                    }

                    //현 결재 상태가 InActive(2)여야만 결재 가능하다.
                    if (curWI.State != (int)ProcessStateChart.WorkItemState.InActive || curWI.ViewState != (int)ProcessStateChart.WorkItemViewState.InProgress)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }
                    //curWI.CompletedDate = strPublishDate; //=> 2012-05-17 아래로 이동

                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(curWI.OID);
                    //프로세스가 진행중 또는 멈춤 상태가 아니면 결재 불가
                    if (pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress && pi.State != (int)ProcessStateChart.ProcessInstanceState.Pause)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    //2011-06-29 추가 : 서비스 모드 여부 및 간격 가져오기
                    strReturn = "[210]";
                    if (Session["FlowSvcMode"] != null)
                    {
                        if (Session["FlowSvcMode"].ToString().Substring(0, 1) == "Y")  //전체 설정
                        {
                            bSvcMode = true;
                            iSvcInterval = Convert.ToInt32(Session["FlowSvcMode"].ToString().Substring(1));
                        }
                        else
                        {
                            bSvcMode = false;
                            iSvcInterval = 0;
                        }
                        if (iSvcInterval > 0)
                        {
                            strPublishDate = (Convert.ToDateTime(strPublishDate).AddMinutes((double)iSvcInterval)).ToString("yyyy-MM-dd HH:mm:ss");
                            curWI.CompletedDate = strPublishDate;
                        }
                    }

                    if (!bSvcMode)
                    {
                        strReturn = "[300]";
                        curActivity = procDac.GetProcessActivity(curWI.ActivityID);

                        strReturn = "[301]";
                        if ((curActivity.ActivityPreCond == "Y") || (curActivity.ActivityPostCond == "Y")
                                    || (curActivity.WorkItemPreCond == "Y") || (curActivity.WorkItemPostCond == "Y"))
                        {
                            Attributes attList = procDac.SelectProcessAttribute(0, pi.ProcessID, curActivity.ActivityID);
                            curActivity.ConditionAttributes = attList;
                        }
                        //strReturn = "[401]";
                        //ResponseText(curActivity.ConditionAttributes.Count.ToString()); return;
                        //strReturn = "[410]";
                        //int z = 1;
                        //foreach (Phs.BFF.Entities.Attribute att in curActivity.ConditionAttributes.Items)
                        //{
                        //    strReturn = "[420]" + z.ToString();
                        //    ResponseText("attid->" + att.ActivityID
                        //                + " att1->" + att.Attribute1
                        //                + " cond->" + att.Condition
                        //                + " pos->" + att.Pos
                        //                + " stat->" + att.Status.ToString()
                        //                + " item2->" + att.Item2 + Environment.NewLine);
                        //    z++;
                        //}
                        //return;

                        strReturn = "[400]";
                        originWiList = procDac.SelectWorkItems(pi.OID);
                    }
                }
                //ResponseText("mi->" + this._msgID); return;

                strReturn = "[500]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfInst = eaDac.SelectXFMainEntity(this._xfAlias, Convert.ToInt32(this._msgID));
                    //if (xfInst != null) xfInst.MessageID = Convert.ToInt32(this._msgID);

                    if (!bSvcMode)
                    {
                        //if (oFormInfo.ChildNodes.Count > 0)
                        //{
                        strReturn = "[510]";
                        //ResponseText("formid->" + xfInst.FormID); return;
                        //xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                        //}
                        //ResponseText("formid=>" + xfInst.FormID); return;
                    }
                    strReturn = "[520]"; // 22-0701 서비스 모드 상관 없이 생성
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                }
                strReturn = "외부키 처리";
                if (curWI.ActRole == "__ri") xfInst.ExternalKey2 = jDoc["key2"].ToString();

                //ResponseText("key2->" + xfInst.ExternalKey2); return;

                if ((jFile != null && jFile.Count > 0) || (jImg != null && jImg.Count > 0))
                {
                    strReturn = "첨부 파일 처리";
                    //AttachInfo(cn, "edit", ref oFileInfo);
                    //strFileInfo = oFileInfo.OuterXml;
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), _xfAlias, jFile, jImg
                                            , (jMain != null && jMain.ContainsKey("WEBEDITOR") ? jMain["WEBEDITOR"].ToString() : ""));
                    if (svcRt.ResultCode != 0)
                    {
                        throw new Exception(svcRt.ResultMessage);
                    }
                    else
                    {
                        jFile = (JArray)svcRt.ResultDataDetail["FileInfo"];
                        if (jImg != null && jImg.Count > 0)
                        {
                            postData["imglist"] = (JArray)svcRt.ResultDataDetail["ImgInfo"];
                            if (jMain != null && jMain.ContainsKey("WEBEDITOR")) jMain["WEBEDITOR"] = svcRt.ResultDataDetail["Body"].ToString();
                        }
                    }
                    attachHdr = null;

                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    foreach (JObject j in jFile)
                    {
                        if (j.ContainsKey("fld") && j["fld"].ToString() != "")
                        {
                            if (j["fld"].ToString().IndexOf(";") > 0)
                            {
                                //하위테이블 필드에서 찾기 : 필드명 + 하위테이블번호 + row 번호 (2015-03-26)
                                string[] vFld = j["fld"].ToString().Split(';');
                                if (jSub != null && jSub.ContainsKey("subtable" + vFld[1]))
                                {
                                    foreach (JObject o in jSub["subtable" + vFld[1]])
                                    {
                                        if (o["ROWSEQ"].ToString() == vFld[2])
                                        {
                                            o[vFld[0]] = j["filename"].ToString() + ";" + j["savedname"].ToString(); break;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //메인테이블 필드에서 찾기
                                if (jMain != null && jMain.ContainsKey(j["fld"].ToString())) jMain[j["fld"].ToString()] = j["filename"].ToString() + ";" + j["savedname"].ToString();

                            }
                        }
                    }

                    if (jImg.Count > 0) foreach (JObject j in jImg) jFile.Add(j);
                    if (jFile.Count > 0) strFileInfo = WorkListHelper.JsonToXmlAttachList(jFile);
                }
                //ResponseText("strFileInfo=>"+strFileInfo); return;
                //ResponseText("aa=>" + oFormInfo.SelectSingleNode("subtables").OuterXml.ToString()); return;

                //strAttInfo = (oProcInfo.SelectSingleNode("attributes") != null) ? oProcInfo.SelectSingleNode("attributes").OuterXml : "";

                //ResponseText("strAttInfo => " + strAttInfo); return;

                strReturn = "참여자 구성";
                //Response.Write(" 여기 => " + oProcInfo["signline"].OuterXml.ToString()); return;
                paramWiList = WorkListHelper.ConvertJsonLineToWorkItemList(curWI, (JArray)jProcess["signline"]);

                strReturn = "삭제될 결재선 처리";
                if (jProcess.ContainsKey("deleted")) strDeleteLine = jProcess["deleted"].ToString();

                strReturn = "인스턴스 속성 정보 할당";
                strAttInfo = "";
                if (jProcess["attributes"] != null)
                {
                    foreach (JObject j in jProcess["attributes"])
                    {
                        if (j["att"].ToString() == "mail_dl" && j["actid"].ToString() == "") j["actid"] = curWI.WorkItemID;
                    }
                    strAttInfo = WorkListHelper.JsonToXmlAttributes((JArray)jProcess["attributes"]);
                }

                //ResponseText("strAttInfo => " + strAttInfo); return;

                if ((jMain != null && jMain.Count > 0) || (jSub != null && jSub.Count > 0))
                {
                    strReturn = "양식 데이타 처리";
                    strFormInfo = WorkListHelper.JsonToXmlFormInfo((JObject)postData["form"], xfDef.SubTableCount);
                    //strReturn = "외부연동 데이타 처리";
                    //strExtraInfo = StringExtraInfo(xfInst, curWI, paramWiList, oFormInfo, oDocInfo);
                }

                strReturn = "결재 종류 설정";
                curWI.SignStatus = WorkListHelper.ConvertSignStatus(_signStatus);
                if (curWI.ActRole.IndexOf("__") >= 0)
                {
                    //XmlNode n = oProcInfo.SelectSingleNode("//line[@parent='" + curWI.WorkItemID + "' and @step='1']");
                    //if (n != null) curWI.Signature = SignImg(Session["CompanyCode"].ToString(), n.SelectSingleNode("part2").InnerText);
                    //위처럼 가져와야 정석, 하지만 part2를 현재(2010.3.5) 가져오지 않고 있기에 아래와 같이 한다.
                    curWI.Signature = SignImg(Session["CompanyCode"].ToString(), Session["LogonID"].ToString());
                }
                else
                {
                    curWI.Signature = SignImg(Session["CompanyCode"].ToString(), curWI.ParticipantInfo2);
                }
                curWI.CompletedDate = strPublishDate;
                //ResponseText(":::rsvd1=>" + oFormInfo.SelectSingleNode("//subtables").OuterXml); return;

                //WorkItem x = null;
                //for (int z = 0; z < paramWiList.Items.Count; z++)
                //{
                //    x = paramWiList.Items[z];
                //    ResponseText("name->" + x.ParticipantName
                //                + " mode->" + x.Mode.ToString()
                //                + " step->" + x.Step.ToString()
                //                + " substep->" + x.SubStep.ToString()
                //                + " viewdate->" + x.ViewDate
                //                + " partid->" + x.ParticipantID
                //                + " comment->" + x.Comment + Environment.NewLine);
                //}
                //return;

                if (bSvcMode)
                {
                    //서비스 모드인 경우
                    strReturn = "서비스 처리";
                    string strFormSchema = Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                    string strFormPath = Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                    using (Engine engineTx = new Engine())
                    {
                        svcRt = engineTx.SendBFFServiceQueue(paramWiList, curWI, null, Environment.MachineName, Convert.ToInt32(Session["DNID"]), Session["CompanyCode"].ToString()
                                                    , (int)ProcessStateChart.BFFServiceState.Pending, 0, strPublishDate, _xfAlias, this._msgID, xfInst.FormID, pi.OID.ToString(), this._workItemID, curWI.SignStatus
                                                    , "", Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptAlias"].ToString()
                                                    , Session["MainSuffix"].ToString(), Framework.Configuration.Config.Read("RootFolder"), strFormSchema, strFormPath, strFormInfo, strFileInfo
                                                    , strAttInfo, strDeleteLine, Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString(), "");
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
                else
                {
                    strReturn = "프로세스 처리";
                    using (Engine engineTx = new Engine())
                    {
                        engineTx.CompanyCode = Session["CompanyCode"].ToString();
                        engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                        engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                        engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                        svcRt = engineTx.DoWorkItem(xfDef, xfInst, pi, curActivity, curWI, paramWiList, strDeleteLine, strAttInfo, strFormInfo, strFileInfo);
                        //strReturn = engineTx.DoWorkItem(cn, xfDef, xfInst, pi, curActivity, paramWiList
                        //                        , strMailInfo, strAttInfo, strFormInfo, strExtraInfo);
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString;
                    else strReturn = svcRt.ResultMessage;

                    //if (strReturn == "OK")
                    //{
                        //strReturn += strTimeStamp;
                        //try
                        //{
                        //    strReturn = "메일발송,외부시스템연동->" + strTimeStamp;
                        //    using (Phs.BFF.Interface.InterfaceNTx ifService = new Phs.BFF.Interface.InterfaceNTx())
                        //    {
                        //        //string strFormSchema = @"d:\phekp\ksea\ea\controls\ph_xform_ea.xml";
                        //        //string strFormPath = @"d:\phekp\ksea\ea\forms\" + Session["DNAlias"].ToString();
                        //        string strFormSchema = Server.MapPath("/" + Application["rootFolderName"].ToString() + "/EA/Controls/ph_xform_ea.xml");
                        //        string strFormPath = Server.MapPath("/" + Application["rootFolderName"].ToString() + "/EA/Forms/" + Session["DNAlias"].ToString());

                        //        ifService.SendSync(Session["DNID"].ToString(), "", strTimeStamp, Application["DomainName"].ToString()
                        //                            , Session["FRONTNAME"].ToString(), Application["rootFolderName"].ToString()
                        //                            , strFormSchema, strFormPath, "", "");
                        //    }
                        //    strReturn = "OK";
                        //}
                        //catch (Exception ex)
                        //{
                        //    strReturn = "OK" + "메일발송,외부시스템연동 중 오류가 발생됐습니다!"
                        //            + Environment.NewLine + "** 결재처리는 정상적으로 수행되었습니다. 관리자에게 문의 바랍니다";

                        //    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.ERROR, "Interface=>" + strTimeStamp);
                        //}
                    //}
                }
            }
            catch (Exception ex)
            {
                if (!bNotice)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "SingleApproval");
                    strReturn = "[ERROR]결재 처리 중 오류 발생!" + Environment.NewLine + strReturn;
                    //strReturn = "[ERROR]" + strReturn;// +Environment.NewLine + ex.Message;
                }
            }
            finally
            {
                xfDef = null;
                xfInst = null;
                pi = null;
                curActivity = null;
                paramWiList = null;
                curWI = null;
            }

            return strReturn;
        }
        #endregion

        #region [반려,지정반려 처리]
        /// <summary>
        /// 반려,지정반려 처리
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string DoReject(JObject postData)
        {
            string strReturn = "현 결재작업 필수정보가 누락 되었습니다!";
            if ((this._processID == "") || (this._workItemID == "")) return strReturn;

            strReturn = "결재상태값이 없습니다!";
            if (this._signStatus == "") return strReturn;

            JObject jBiz = null;
            JObject jDoc = null;
            JObject jForm = null;
            JArray jFile = null;
            JObject jParam = null;
            JObject jTarget = null;
            

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            ProcessInstance pi = null;
            Activity curActivity = null;
            WorkItemList originWiList = null;
            WorkItem curWI = null;
            WorkItem paramWI = null;
            WorkItem targetWI = null;

            SchemaList schemaAct = null;
            WorkItemList paramWiList = null;
            Hashtable htInto = null;

            string strNow = "";
            string strPublishDate = "";
            //string strDeleteLine = "";
            string strFormInfo = "";
            string strFileInfo = "";
            string strTimeStamp = "";

            bool bNotice = false;
            bool bSvcMode = false;      //2011-06-29 추가 : 서비스모드로 처리 여부
            int iSvcInterval = 10;      //2011-06-29 추가 : 서비스모드로 처리 시간 간격(기본 10분)

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "JSON 객체 할당";  //strReturn = "XML 객체 생성";

                jBiz = (JObject)postData["biz"];
                jDoc = (JObject)postData["doc"];
                jForm = (JObject)postData["form"];
                jFile = (JArray)postData["attachlist"];
                jParam = (JObject)postData["process"]["param"];
                jTarget = (JObject)postData["process"]["target"];

                //oProcInfo = xmlDoc.SelectSingleNode("//processinfo");
                //oDocInfo = xmlDoc.SelectSingleNode("//docinfo");
                //oFileInfo = xmlDoc.SelectSingleNode("//fileinfo");
                //oFormInfo = xmlDoc.SelectSingleNode("//forminfo");
                //curNode = oProcInfo.SelectSingleNode("current");
                //paramNode = oProcInfo.SelectSingleNode("line");
                //targetNode = oProcInfo.SelectSingleNode("target");

                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                strReturn = "데이타베이스 연결 오류";
                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    curWI = procDac.SelectWorkItem(this._workItemID);

                    if ((curWI.PartType.Substring(0, 1) == "u") && (curWI.ParticipantID != Session["URID"].ToString()))
                    {
                        strReturn = "현 결재자와 접속자 정보가 틀립니다!";
                        return strReturn;
                    }

                    //현 결재 상태가 InActive(2)여야만 결재 가능하다.
                    if (curWI.State != (int)ProcessStateChart.WorkItemState.InActive || curWI.ViewState != (int)ProcessStateChart.WorkItemViewState.InProgress)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    if (jTarget.Count > 0)
                    {
                        strReturn = "[110]";
                        if (jTarget["wid"].ToString() != "" && jTarget["partid"].ToString() != "")
                        {
                            targetWI = procDac.SelectWorkItem(jTarget["wid"].ToString());
                        }
                    }

                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(curWI.OID);
                    //프로세스가 진행중 또는 멈춤 상태가 아니면 결재 불가
                    if (pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress && pi.State != (int)ProcessStateChart.ProcessInstanceState.Pause)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    //2011-06-29 추가 : 서비스 모드 여부 및 간격 가져오기
                    strReturn = "[210]";
                    if (Session["FlowSvcMode"] != null)
                    {
                        if (Session["FlowSvcMode"].ToString().Substring(0, 1) == "Y")  //전체 설정
                        {
                            bSvcMode = true;
                            iSvcInterval = Convert.ToInt32(Session["FlowSvcMode"].ToString().Substring(1));
                        }
                        else
                        {
                            bSvcMode = false;
                            iSvcInterval = 0;
                        }
                        if (iSvcInterval > 0)
                        {
                            strPublishDate = (Convert.ToDateTime(strPublishDate).AddMinutes((double)iSvcInterval)).ToString("yyyy-MM-dd HH:mm:ss");
                            curWI.CompletedDate = strPublishDate;
                        }
                    }

                    if (!bSvcMode)
                    {
                        strReturn = "[300]";
                        curActivity = procDac.GetProcessActivity(curWI.ActivityID);

                        strReturn = "[400]";
                        if ((curActivity.ActivityPreCond == "Y") || (curActivity.ActivityPostCond == "Y")
                                    || (curActivity.WorkItemPreCond == "Y") || (curActivity.WorkItemPostCond == "Y"))
                        {
                            Attributes attList = procDac.SelectProcessAttribute(0, pi.ProcessID, curWI.ActivityID);
                            curActivity.ConditionAttributes = attList;
                        }
                    }

                    strReturn = "[410]";
                    originWiList = procDac.SelectWorkItems(pi.OID);
                }
                //ResponseText("reject->" + _msgID); return;


                strReturn = "[500]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfInst = eaDac.SelectXFMainEntity(this._xfAlias, Convert.ToInt32(this._msgID));
                    //if (!bSvcMode)
                    //{
                    //    strReturn = "[510]";
                    //    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                    //}
                    strReturn = "[520]"; // 22-0701 서비스 모드 상관 없이 생성
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                }

                strReturn = "현 결재자 정보 설정";
                curWI.SignStatus = WorkListHelper.ConvertSignStatus(_signStatus);
                //curWI.Mode = ProcessStateChart.SignLineModification.Update;
                //curWI.ViewState = (int)ProcessStateChart.WorkItemViewState.InProgress;
                curWI.CompletedDate = strPublishDate;
                curWI.Comment = (postData.ContainsKey("cmnt")) ? postData["cmnt"].ToString() : "";
                if (curWI.ActRole.IndexOf("__") >= 0)
                {
                    //if (paramNode != null) curWI.Signature = SignImg(Session["CompanyCode"].ToString(), paramNode.SelectSingleNode("part2").InnerText);
                    //위처럼 가져와야 정석, 하지만 part2를 현재(2010.3.5) 가져오지 않고 있기에 아래와 같이 한다.
                    curWI.Signature = SignImg(Session["CompanyCode"].ToString(), Session["LogonID"].ToString());
                }
                else
                {
                    curWI.Signature = SignImg(Session["CompanyCode"].ToString(), curWI.ParticipantInfo2);
                }
                //ResponseText(":::rsvd1->" + curWI.Signature); return;

                if (jParam.Count > 0)
                {
                    strReturn = "담당자 정보 설정";
                    paramWI = new WorkItem();
                    paramWI.Mode = ProcessStateChart.SignLineModification.Insert;
                    paramWI.WorkItemID = ProcessStateChart.NewGuid();
                    paramWI.OID = curWI.OID;
                    paramWI.ParentWorkItemID = jParam["parent"].ToString();
                    paramWI.Priority = 0;

                    strReturn = "[610]";
                    paramWI.Step = Convert.ToInt32(jParam["step"].ToString());
                    paramWI.SubStep = Convert.ToInt32(jParam["substep"].ToString());
                    paramWI.Seq = Convert.ToInt32(jParam["seq"].ToString());
                    paramWI.State = Convert.ToInt32(jParam["state"].ToString());
                    paramWI.SignStatus = Convert.ToInt32(jParam["signstatus"].ToString());
                    paramWI.SignKind = Convert.ToInt32(jParam["signkind"].ToString());
                    paramWI.ViewState = (int)ProcessStateChart.WorkItemViewState.InProgress;

                    strReturn = "[620]";
                    paramWI.ActivityID = jParam["activityid"].ToString();
                    paramWI.BizRole = jParam["bizrole"].ToString();
                    paramWI.ActRole = jParam["actrole"].ToString();
                    paramWI.PartType = jParam["parttype"].ToString();
                    paramWI.ParticipantID = jParam["partid"].ToString();
                    paramWI.ParticipantDeptCode = jParam["deptcode"].ToString();
                    paramWI.CompetencyCode = jParam.ContainsKey("competency") ? 0 : StringHelper.SafeInt(jParam["competency"].ToString());
                    paramWI.Point = (jParam["point"] == null) ? "" : jParam["point"].ToString();
                    paramWI.Limited = "";

                    strReturn = "[630]";
                    paramWI.ReceivedDate = jParam.ContainsKey("received") ? jParam["received"].ToString() : "";
                    paramWI.CompletedDate = jParam.ContainsKey("completed") ? jParam["completed"].ToString() : "";
                    paramWI.ViewDate = jParam.ContainsKey("view") ? jParam["view"].ToString() : "";
                    paramWI.ParticipantName = jParam["partname"].ToString();
                    //wi.Comment = (paramNode.SelectSingleNode("comment") == null) ? "" : paramNode.SelectSingleNode("comment").InnerText;

                    if (bSvcMode)
                    {
                        paramWiList = new WorkItemList();
                        paramWiList.Add(paramWI);
                    }
                }

                if (curWI.SignStatus == (int)ProcessStateChart.SignStatus.Reject)
                {
                    strReturn = "[640]";
                    using (WorkList workList = new WorkList())
                    {
                        schemaAct = workList.RetrieveSchemaList(pi.ProcessID, curWI.OID, curWI.Step, curWI.ActivityID, curWI.ParentWorkItemID, xfInst.FormID);
                    }

                    strReturn = "[650]";
                    htInto = new Hashtable();
                    htInto.Add("oid", pi.OID);
                    htInto.Add("URID", Session["URID"].ToString());
                    htInto.Add("URName", Session["URName"].ToString());
                    htInto.Add("LogonID", Session["LogonID"].ToString());
                    htInto.Add("URACCOUNT", Session["URACCOUNT"].ToString());
                    htInto.Add("GRADE1", Session["GRADE1"].ToString());
                    htInto.Add("DeptID", Session["DeptID"].ToString());
                    htInto.Add("DeptAlias", Session["DeptAlias"].ToString());
                    htInto.Add("DeptName", Session["DeptName"].ToString());

                    strReturn = "[800]";
                    paramWiList = WorkListHelper.LineList(originWiList, schemaAct, curWI, htInto);
                }

                if (targetWI != null)
                {
                    strReturn = "지정 반려 대상 설정";
                    //Engine에서 설정
                    if (targetWI.ParticipantID.IndexOf('_') >= 0) targetWI.ParticipantID = targetWI.ParticipantID.Split('_')[0];

                }
                //ResponseText("A=>" + paramWI.ParticipantName + "__[" + paramWI.ParentWorkItemID + "] ");
                //return;

                strReturn = "외부키 처리";
                //ResponseText("docinfo->" + oDocInfo.OuterXml); return;
                if (curWI.ActRole == "__ri") xfInst.ExternalKey2 = jDoc["key2"].ToString();
                //ResponseText("*key2->" + xfInst.ExternalKey2); return;

                if (jFile != null && jFile.Count > 0)
                {
                    strReturn = "첨부파일 처리";
                    strFileInfo = WorkListHelper.JsonToXmlAttachList(jFile);
                    //ResponseText("file->" + strFileInfo); return;                
                }
                //반려인 경우는 추가정보로 사유를 넣는다.
                //strExtraInfo = curWI.Comment;

                if (jForm != null && jForm.Count > 0)
                {
                    strReturn = "양식 데이타 처리";
                    strFormInfo = WorkListHelper.JsonToXmlFormInfo(jForm, xfDef.SubTableCount);

                    //strReturn = "외부연동 데이타 처리";
                    //strExtraInfo = StringExtraInfo(xfInst, curWI, null, oFormInfo, oDocInfo);
                }

                if (bSvcMode)
                {
                    ///서비스 모드인 경우
                    strReturn = "서비스 처리";
                    string strFormSchema = Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                    string strFormPath = Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                    using (Engine engineTx = new Engine())
                    {
                        svcRt = engineTx.SendBFFServiceQueue(paramWiList, curWI, targetWI, Environment.MachineName, Convert.ToInt32(Session["DNID"]), Session["CompanyCode"].ToString()
                                                    , (int)ProcessStateChart.BFFServiceState.Pending, 0, strPublishDate, _xfAlias, this._msgID, xfInst.FormID, pi.OID.ToString(), this._workItemID, curWI.SignStatus
                                                    , "", Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptAlias"].ToString()
                                                    , Session["MainSuffix"].ToString(), Framework.Configuration.Config.Read("RootFolder"), strFormSchema, strFormPath, strFormInfo, strFileInfo
                                                    , "", "", Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString(), "");
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
                else
                {
                    strReturn = "프로세스 처리";
                    using (Engine engineTx = new Engine())
                    {
                        engineTx.CompanyCode = Session["CompanyCode"].ToString();
                        engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                        engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                        engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                        if (curWI.SignStatus == (int)ProcessStateChart.SignStatus.Back)
                        {
                            svcRt = engineTx.DoWorkItemBack(xfDef, xfInst, pi, curActivity, curWI, paramWI, targetWI, strFormInfo, strFileInfo);
                        }
                        else
                        {
                            svcRt = engineTx.DoWorkItemReject(xfDef, xfInst, pi, curActivity, curWI, paramWiList, strFormInfo, strFileInfo);
                        }
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString;
                    else strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                if (!bNotice)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DoReject");
                    strReturn = "[ERROR]반려 처리 중 오류 발생!" + Environment.NewLine + strReturn;
                    //strReturn = "[ERROR]" + strReturn;// +Environment.NewLine + ex.Message;
                }
            }
            finally
            {
                xfInst = null;
                xfDef = null;
                pi = null;
                curActivity = null;
                curWI = null;
                paramWI = null;
                targetWI = null;
                schemaAct = null;
                paramWiList = null;
                originWiList = null;
            }

            return strReturn;
        }
        #endregion

        #region [보류 처리]
        /// <summary>
        /// 보류 처리
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string DoReserve(JObject postData)
        {
            string strReturn = "현 결재작업 필수정보가 누락 되었습니다!";
            if (_workItemID == "") return strReturn;

            strReturn = "결재상태값이 없습니다!";
            if (_signStatus == "") return strReturn;

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            ProcessInstance pi = null;
            Activity curActivity = null;
            WorkItem curWI = null;

            string strNow = "";
            string strPublishDate = "";
            string strTimeStamp = "";

            bool bNotice = false;

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                
                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    curWI = procDac.SelectWorkItem(_workItemID);

                    if ((curWI.PartType.Substring(0, 1) == "u") && (curWI.ParticipantID != Session["URID"].ToString()))
                    {
                        strReturn = "현 결재자와 접속자 정보가 틀립니다!";
                        return strReturn;
                    }

                    //현 결재 상태가 InActive(2)여야만 결재 가능하다.
                    if (curWI.State != (int)ProcessStateChart.WorkItemState.InActive || curWI.ViewState != (int)ProcessStateChart.WorkItemViewState.InProgress)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(curWI.OID);
                    //프로세스가 진행중 또는 멈춤 상태가 아니면 결재 불가
                    if (pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress && pi.State != (int)ProcessStateChart.ProcessInstanceState.Pause)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    strReturn = "[300]";
                    curActivity = procDac.GetProcessActivity(curWI.ActivityID);

                    strReturn = "[301]";
                    if ((curActivity.ActivityPreCond == "Y") || (curActivity.ActivityPostCond == "Y")
                                || (curActivity.WorkItemPreCond == "Y") || (curActivity.WorkItemPostCond == "Y"))
                    {
                        Attributes attList = procDac.SelectProcessAttribute(0, pi.ProcessID, curActivity.ActivityID);
                        curActivity.ConditionAttributes = attList;
                    }
                }

                strReturn = "[400]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfInst = eaDac.SelectXFMainEntity(this._xfAlias, Convert.ToInt32(postData["mi"]));

                    strReturn = "[410]";
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                }

                strReturn = "[500]";
                curWI.SignStatus = WorkListHelper.ConvertSignStatus(_signStatus);
                curWI.CompletedDate = strPublishDate;
                curWI.Comment = postData["cmnt"].ToString();
                curWI.Signature = SignImg(Session["CompanyCode"].ToString(), Session["LogonID"].ToString());

                using (Engine engineTx = new Engine())
                {
                    engineTx.CompanyCode = Session["CompanyCode"].ToString();
                    engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                    engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                    engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                    svcRt = engineTx.DoWorkItemReserve(xfDef, xfInst, pi, curActivity, curWI);
                }

                if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString;
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                if (!bNotice)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DoReserve");
                    strReturn = "[ERROR]결재 처리 중 오류 발생!" + Environment.NewLine + strReturn;
                }
            }
            finally
            {
                xfDef = null;
                xfInst = null;
                pi = null;
                curActivity = null;
                curWI = null;
            }
            return strReturn;
        }
        #endregion

        #region [일괄/단순 결재]
        /// <summary>
        /// 
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string SimpleApproval(JObject postData)
        {
            string strReturn = "현 결재작업 필수정보가 누락 되었습니다!";
            if (_workItemID == "") return strReturn;

            strReturn = "결재상태값이 없습니다!";
            if (_signStatus == "") return strReturn;

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            ProcessInstance pi = null;
            Activity curActivity = null;
            SchemaList schemaAct = null;
            WorkItemList paramWiList = null;
            WorkItemList originWiList = null;
            WorkItem curWI = null;
            Hashtable htInto = null;

            string strNow = "";
            string strPublishDate = "";
            string strTimeStamp = "";

            bool bNotice = false;
            bool bSvcMode = false;      //2011-06-29 추가 : 서비스모드로 처리 여부
            int iSvcInterval = 10;      //2011-06-29 추가 : 서비스모드로 처리 시간 간격(기본 10분)

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    curWI = procDac.SelectWorkItem(_workItemID);

                    if ((curWI.PartType.Substring(0, 1) == "u") && (curWI.ParticipantID != Session["URID"].ToString()))
                    {
                        strReturn = "현 결재자와 접속자 정보가 틀립니다!";
                        return strReturn;
                    }

                    //현 결재 상태가 InActive(2)여야만 결재 가능하다.
                    if (curWI.State != (int)ProcessStateChart.WorkItemState.InActive || curWI.ViewState != (int)ProcessStateChart.WorkItemViewState.InProgress)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(curWI.OID);
                    //프로세스가 진행중 또는 멈춤 상태가 아니면 결재 불가
                    if (pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress && pi.State != (int)ProcessStateChart.ProcessInstanceState.Pause)
                    {
                        strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                        return strReturn;
                    }

                    //2011-06-29 추가 : 서비스 모드 여부 및 간격 가져오기
                    strReturn = "[210]";
                    if (_signStatus == "reserve")
                    {
                        bSvcMode = false;
                        iSvcInterval = 0;
                    }
                    else
                    {
                        if (Session["FlowSvcMode"] != null)
                        {
                            if (Session["FlowSvcMode"].ToString().Substring(0, 1) == "Y")  //전체 설정
                            {
                                bSvcMode = true;
                                iSvcInterval = Convert.ToInt32(Session["FlowSvcMode"].ToString().Substring(1));
                            }
                            else
                            {
                                bSvcMode = false;
                                iSvcInterval = 0;
                            }
                            if (iSvcInterval > 0)
                            {
                                strPublishDate = (Convert.ToDateTime(strPublishDate).AddMinutes((double)iSvcInterval)).ToString("yyyy-MM-dd HH:mm:ss");
                                curWI.CompletedDate = strPublishDate;
                            }
                        }
                    }

                    if (!bSvcMode)
                    {
                        strReturn = "[300]";
                        curActivity = procDac.GetProcessActivity(curWI.ActivityID);

                        strReturn = "[301]";
                        if ((curActivity.ActivityPreCond == "Y") || (curActivity.ActivityPostCond == "Y")
                                    || (curActivity.WorkItemPreCond == "Y") || (curActivity.WorkItemPostCond == "Y"))
                        {
                            Attributes attList = procDac.SelectProcessAttribute(0, pi.ProcessID, curActivity.ActivityID);
                            curActivity.ConditionAttributes = attList;
                        }
                    }

                    strReturn = "[400]";
                    originWiList = procDac.SelectWorkItems(pi.OID);
                }

                strReturn = "[500]";
                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    xfInst = eaDac.SelectXFMainEntity(this._xfAlias, pi.MessageID);
                    //if (!bSvcMode)
                    //{
                    //    strReturn = "[510]";
                    //    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                    //}
                    strReturn = "[520]"; // 22-0701 서비스 모드 상관 없이 생성
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(Session["DNID"]), xfInst.FormID);
                }

                strReturn = "[600]";
                using (WorkList workList = new WorkList())
                {
                    schemaAct = workList.RetrieveSchemaList(pi.ProcessID, curWI.OID, curWI.Step, curWI.ActivityID, curWI.ParentWorkItemID, xfInst.FormID);
                }

                strReturn = "[700]";
                curWI.SignStatus = WorkListHelper.ConvertSignStatus(_signStatus);
                curWI.CompletedDate = strPublishDate;
                curWI.Comment = postData["cmnt"].ToString();
                curWI.Signature = SignImg(Session["CompanyCode"].ToString(), Session["LogonID"].ToString()); //postData["sign"].ToString();

                strReturn = "[710]";
                htInto = new Hashtable();
                htInto.Add("oid", pi.OID);
                htInto.Add("URID", Session["URID"].ToString());
                htInto.Add("URName", Session["URName"].ToString());
                htInto.Add("LogonID", Session["LogonID"].ToString());
                htInto.Add("URACCOUNT", Session["URACCOUNT"].ToString());
                htInto.Add("GRADE1", Session["GRADE1"].ToString());
                htInto.Add("DeptID", Session["DeptID"].ToString());
                htInto.Add("DeptAlias", Session["DeptAlias"].ToString());
                htInto.Add("DeptName", Session["DeptName"].ToString());

                strReturn = "[800]";
                paramWiList = WorkListHelper.LineList(originWiList, schemaAct, curWI, htInto);

                //ResponseText("A=>" + paramWiList.Items[0].ParticipantName + "__[" + paramWiList.Items[0].ParentWorkItemID + "] ");
                //ResponseText("B=>" + paramWiList.Items[1].ParticipantName + "__[" + paramWiList.Items[1].ParentWorkItemID + "] ");
                //ResponseText("C=>" + paramWiList.Items[2].ParticipantName + "__[" + paramWiList.Items[2].ParentWorkItemID + "] ");
                //ResponseText("D=>" + paramWiList.Items[3].ParticipantName + "__[" + paramWiList.Items[3].ParentWorkItemID + "] ");
                //ResponseText("E=>" + paramWiList.Items[4].ParticipantName + "__[" + paramWiList.Items[4].ParentWorkItemID + "] ");
                //ResponseText("F=>" + paramWiList.Items[5].ParticipantName + "__[" + paramWiList.Items[5].ParentWorkItemID + "] ");

                //return;

                if (bSvcMode)
                {
                    //서비스 모드인 경우
                    string strFormSchema = Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                    string strFormPath = Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                    using (Engine engineTx = new Engine())
                    {
                        svcRt = engineTx.SendBFFServiceQueue(paramWiList, curWI, null, Environment.MachineName, Convert.ToInt32(Session["DNID"]), Session["CompanyCode"].ToString()
                                                    , (int)ProcessStateChart.BFFServiceState.Pending, 0, strPublishDate, _xfAlias, pi.MessageID.ToString(), xfInst.FormID, pi.OID.ToString(), curWI.WorkItemID, curWI.SignStatus
                                                    , "", Convert.ToInt32(Session["URID"]), Session["LogonID"].ToString(), Convert.ToInt32(Session["DeptID"]), Session["DeptAlias"].ToString()
                                                    , Session["MainSuffix"].ToString(), Framework.Configuration.Config.Read("RootFolder"), strFormSchema, strFormPath
                                                    , "", "", "", "", Request.ServerVariables["REMOTE_HOST"].ToString(), Request.ServerVariables["HTTP_USER_AGENT"].ToString(), "");
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
                else
                {
                    strReturn = "[910]";
                    using (Engine engineTx = new Engine())
                    {
                        engineTx.CompanyCode = Session["CompanyCode"].ToString();
                        engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                        engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                        engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                        if (curWI.SignStatus == (int)ProcessStateChart.SignStatus.Reject)
                        {
                            svcRt = engineTx.DoWorkItemReject(xfDef, xfInst, pi, curActivity, curWI, paramWiList, "", "");
                        }
                        else if (curWI.SignStatus == (int)ProcessStateChart.SignStatus.Reserve)
                        {
                            svcRt = engineTx.DoWorkItemReserve(xfDef, xfInst, pi, curActivity, curWI);
                        }
                        else
                        {
                            svcRt = engineTx.DoWorkItem(xfDef, xfInst, pi, curActivity, curWI, paramWiList, "", "", "", "");
                        }
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK" + svcRt.ResultDataString;
                    else strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                if (!bNotice)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "SimpleApproval");
                    strReturn = "[ERROR]결재 처리 중 오류 발생!" + Environment.NewLine + strReturn;
                }
            }
            finally
            {
                xfDef = null;
                xfInst = null;
                pi = null;
                curActivity = null;
                schemaAct = null;
                paramWiList = null;
                originWiList = null;
                curWI = null;
                htInto = null;
            }
            return strReturn;
        }
        #endregion

        #region [선결 처리]
        /// <summary>
        /// 선결 처리, 취소
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string PreApproval(JObject postData)
        {
            string strReturn = "필수정보가 누락 되었습니다!";
            if (postData["mi"].ToString() == "" || postData["wi"].ToString() == "" || postData["ss"].ToString() == "") return strReturn;

            ProcessInstance pi = null;
            WorkItem actWI = null;

            string strNow = "";
            string strPublishDate = "";

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "처리요청일 설정";
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = postData["rd"].ToString();
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                strReturn = "데이타베이스 연결 오류";
                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    actWI = procDac.SelectWorkItem(postData["wi"].ToString());
                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(actWI.OID);
                }

                strReturn = "현 결재자와 접속자 정보가 틀립니다!";
                if (actWI.PartType.Substring(0, 1) == "u" && actWI.ParticipantID != Session["URID"].ToString()) return strReturn;

                strReturn = "현재 문서는 이미 처리 되었거나 처리 할 수 없는 상태입니다!";
                if (actWI.State != (int)ProcessStateChart.WorkItemState.Penging || pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress) return strReturn;

                strReturn = "[700]";
                actWI.SignStatus = WorkListHelper.ConvertSignStatus(postData["ss"].ToString());
                actWI.CompletedDate = strPublishDate;
                actWI.Comment = postData["cmnt"].ToString();
                actWI.Signature = SignImg(Session["CompanyCode"].ToString(), Session["LogonID"].ToString()); //postData["sign"].ToString();

                strReturn = "[800]";
                string strFormSchema = Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                string strFormPath = Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                using (Engine engineTx = new Engine())
                {
                    engineTx.CompanyCode = Session["CompanyCode"].ToString();
                    engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                    engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                    engineTx.CurrentActorId = Session["URID"].ToString();

                    if (postData["ss"].ToString() == "pre_cancel")
                    {
                        strReturn = "[900]"; //선결취소
                        svcRt = engineTx.CancelPreApprovalSend(0, pi.OID.ToString(), actWI.WorkItemID);

                        if (svcRt.ResultCode == 0) strReturn = "OK";
                        else strReturn = svcRt.ResultMessage;
                    }
                    else if (postData["ss"].ToString() != "") //2014-03-20 보완
                    {
                        strReturn = "[910]"; //선결
                        int iSignStatus = WorkListHelper.ConvertSignStatus(postData["ss"].ToString());
                        svcRt = engineTx.SendBFFPreApprovalQueue(Environment.MachineName, Convert.ToInt32(Session["DNID"])
                                        , (int)ProcessStateChart.BFFServiceState.Pending, 0, strPublishDate, _xfAlias, postData["mi"].ToString(), postData["fi"].ToString()
                                        , pi.OID.ToString(), actWI.WorkItemID, iSignStatus, actWI.Signature, actWI.Comment
                                        , Session["URName"].ToString(), Convert.ToInt32(Session["URID"]), Session["DeptName"].ToString(), Convert.ToInt32(Session["DeptID"])
                                        , Session["MainSuffix"].ToString(), Framework.Configuration.Config.Read("RootFolder"), strFormSchema, strFormPath);

                        if (svcRt.ResultCode == 0) strReturn = "OK";
                        else strReturn = svcRt.ResultMessage;
                    }
                    else
                    {
                        strReturn = "요청 상태가 맞지 않습니다!";
                    }
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "PreApproval");
                strReturn = "[ERROR]선결 처리 중 오류 발생!" + Environment.NewLine + strReturn;
            }
            finally
            {
                pi = null;
                actWI = null;
            }
            return strReturn;
        }
        #endregion

        #region [기안 회수/취소, 회수문서 삭제]
        /// <summary>
        /// 기안 회수
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string CancelDraft(JObject postData)
        {
            string strReturn = "필수정보가 누락 되었습니다!";
            if (postData["oi"].ToString() == "" || postData["wi"].ToString() == "") return strReturn;

            ProcessInstance pi = null;
            WorkItemList wiList = null;
            WorkItem actWI = null;
            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            bool bProgress = false;

            try
            {
                strReturn = "데이타베이스 연결 오류";
                using (ProcessDac procDac = new ProcessDac())
                {
                    strReturn = "[100]";
                    actWI = procDac.SelectWorkItem(postData["wi"].ToString());
                    strReturn = "[200]";
                    pi = procDac.SelectProcessInstance(actWI.OID);
                    strReturn = "[300]";
                    wiList = procDac.SelectWorkItems(pi.OID);
                }

                strReturn = "처리 권한이 없습니다!";
                if (actWI.ParticipantID != Session["URID"].ToString() || actWI.ActRole != "_drafter") return strReturn;

                strReturn = "요청 처리 할 수 없는 상태입니다!";
                if (pi.State != (int)ProcessStateChart.ProcessInstanceState.InProgress) return strReturn;

                strReturn = "다음 결재자가 검토 또는 결재 중이므로 처리 할 수 없습니다!";
                //2012-12-05 보완, 2013-04-11 추가 보완
                bProgress = true;
                foreach (WorkItem w in wiList.Items)
                {
                    //if (w.Step == actWI.Step + 1)
                    //{
                    //    if (w.State == (int)Phs.BFF.Entities.ProcessStateChart.WorkItemState.InActive && EApproval.CheckDateTiem(w.ViewDate) == "") { bProgress = true; }
                    //    else { bProgress = false; break; }
                    //}
                    if (w.ParentWorkItemID == "" && w.Step > actWI.Step && w.SignKind != (int)ProcessStateChart.SignKind.ByPass)
                    //&& (w.ActRole == "_approver" || w.ActRole == "__r"))
                    {
                        if (w.State > 2)
                        {
                            //처리중, 부서처리중, 완료, 에러 상태가 있으면 회수 불가
                            bProgress = false; break;
                        }
                    }
                }
                if (bProgress)
                {
                    //연동문서 기안 철회 작업을 위해 2011-12-23
                    using (EApprovalDac eaDac = new EApprovalDac())
                    {
                        strReturn = "[400]";
                        xfInst = eaDac.SelectXFMainEntity(pi.XfAlias, pi.MessageID);
                        strReturn = "[410]";
                        xfDef = eaDac.GetEAFormData(pi.DnID, xfInst.FormID);
                    }

                    ServiceResult svcRt = new ServiceResult();
                    using (Engine engineTx = new Engine())
                    {
                        engineTx.CompanyCode = Session["CompanyCode"].ToString();
                        engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                        engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                        engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                        strReturn = "[500]";
                        //strReturn = engineTx.DoWorkItemWithdraw(cn, pi, xfInst);
                        string strModuleId = "register_a";
                        svcRt = engineTx.DoWorkItemWithdraw(pi, xfInst, xfDef, strModuleId, pi.CreatorID.ToString(), DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "CancelDraft");
                strReturn = "[ERROR]기안 회수 중 오류 발생!" + Environment.NewLine + strReturn;
            }
            finally
            {
                pi = null;
                actWI = null;
                wiList = null;
            }
            return strReturn;
        }

        /// <summary>
        /// 회수된 문서 삭제
        /// </summary>
        /// <param name="postData"></param>
        private string DeleteWithdraw(JObject postData)
        {
            string strReturn = "필수정보가 누락 되었습니다!";
            if (!postData.ContainsKey("tgt")) return strReturn;

            if (postData["tgt"].ToString() != "")
            {
                string strQuery = @"UPDATE admin.PH_XF_EA WITH (ROWLOCK) SET DeleteDate = GETDATE() WHERE MessageID IN (" + postData["tgt"].ToString() + @")
            UPDATE admin.BF_PROCESS_INSTANCE WITH (ROWLOCK) SET DeleteDate = GETDATE() WHERE XFAlias='ea' AND MessageID IN (" + postData["tgt"].ToString() + ")";

                ServiceResult svcRt = new ServiceResult();

                try
                {
                    using (ZumNet.BSL.InterfaceBiz.ExecuteBiz execBiz = new BSL.InterfaceBiz.ExecuteBiz())
                    {
                        svcRt = execBiz.ExecuteQueryTx(strQuery, 30, null);
                    }
                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
                catch (Exception ex)
                {
                    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "DeleteWithdraw");
                    strReturn = ex.Message;
                }
            }
            
            return strReturn;
        }

        /// <summary>
        /// 서비스 요청(승인대기) 취소
        /// </summary>
        /// <param name="postData"></param>
        private string CancelServiceQueue(JObject postData)
        {
            string strReturn = "필수정보가 누락 되었습니다!";
            if (postData["svc"].ToString() == "") return strReturn;

            DataSet ds = null;
            DataRow drSvc = null;
            WorkItem curWI = null;
            bool bProgress = false;

            try
            {
                strReturn = "서비스 정보 조회 오류";
                using (ProcessDac procDac = new ProcessDac())
                {
                    ds = procDac.SelectBFFlowService(long.Parse(postData["svc"].ToString()));
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) drSvc = ds.Tables[0].Rows[0];
                    else return strReturn;

                    strReturn = "처리 권한이 없습니다!" + Environment.NewLine + "새로고침 하십시오.";
                    if (drSvc["RequesterID"].ToString() != Session["URID"].ToString()) return strReturn;

                    strReturn = "이미 처리 됐거나 처리 할 수 없는 상태입니다!" + Environment.NewLine + "새로고침 하십시오.";
                    if (Convert.ToInt32(drSvc["ReqState"]) != (int)ProcessStateChart.BFFServiceState.Pending) return strReturn;

                    if (drSvc["WorkItemID"].ToString() == "")
                    {
                        //기안인 경우 : 추후
                        strReturn = "[200]";
                    }
                    else
                    {
                        strReturn = "[300]";
                        curWI = procDac.SelectWorkItem(drSvc["WorkItemID"].ToString());

                        strReturn = "요청자와 결재자가 틀립니다!" + Environment.NewLine + "새로고침 하십시오.";
                        if (curWI.PartType.Substring(0, 1) == "u" && curWI.ParticipantID != Session["URID"].ToString()) return strReturn;

                        strReturn = "처리 상태가 틀립니다!" + Environment.NewLine + "새로고침 하십시오.";
                        if (curWI.State != (int)ProcessStateChart.WorkItemState.Progressing) return strReturn;
                    }
                    bProgress = true;
                }
                if (bProgress)
                {
                    strReturn = "[400]";
                    ServiceResult svcRt = new ServiceResult();

                    using (Engine engineTx = new Engine())
                    {
                        engineTx.CompanyCode = Session["CompanyCode"].ToString();
                        engineTx.RemoteHost = Request.ServerVariables["REMOTE_HOST"].ToString();
                        engineTx.HttpUserAgent = Request.ServerVariables["HTTP_USER_AGENT"].ToString();
                        engineTx.CurrentActorId = Session["URID"].ToString();   //2012-10-25 추가

                        svcRt = engineTx.CancelServiceSend(postData["svc"].ToString(), _xfAlias, postData["mi"].ToString(), postData["oi"].ToString(), drSvc["WorkItemID"].ToString());
                    }

                    if (svcRt.ResultCode == 0) strReturn = "OK";
                    else strReturn = svcRt.ResultMessage;
                }
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "CancelServiceQueue");
                strReturn = "[ERROR]요청 취소 중 오류 발생!" + Environment.NewLine + strReturn;
            }
            finally
            {
                if (ds != null) ds.Dispose();
                curWI = null;
                drSvc = null;
            }

            return strReturn;
        }
        #endregion

        #region [비밀번호 확인]
        /// <summary>
        /// 결재비밀번호 확인
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string CheckApprovalPassword(JObject postData)
        {
            string strReturn = "";
            bool bCheck = false;
            try
            {
                // ResponseText("AAAA"); return;
                using (ZumNet.BSL.FlowBiz.WorkList workList = new WorkList())
                {
                    //bCheck = workList.CheckApprovalPassword("wfs", Session["DNAlias"].ToString(), Session["URACCOUNT"].ToString(), GetPostData());
                    bCheck = workList.CheckApprovalPassword("", Convert.ToInt32(Session["URID"]), postData["pwd"].ToString());
                }
                if (bCheck) strReturn = "T";
                else strReturn = "F";
            }
            catch (Exception ex)
            {
                strReturn = ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "CheckApprovalPassword");
            }
            return strReturn;
        }

        /// <summary>
        /// 로그인 비밀번호 확인
        /// </summary>
        /// <param name="postData"></param>
        /// <returns></returns>
        private string CheckLogonPassword(JObject postData)
        {
            string strReturn = "F";
            if (Request.ServerVariables["AUTH_PASSWORD"].ToString() == postData["pwd"].ToString()) strReturn = "T";
            
            return strReturn;
        }
        #endregion

        #region [결재이외 양식(금형대장) 저장/수정]
        private string RegisterFormNotEA(JObject postData, string command)
        {
            JObject jMain = null;
            JObject jSub = null;
            JArray jFile = null;
            JArray jImg = null;

            string strReturn = "";
            string strNow = "";
            string strPublishDate = "";
            string strEcnType = ""; //2019-10-15
            int iOId = 0;
            int iSubTableCount = 0;

            ServiceResult svcRt = new ServiceResult();

            try
            {
                strReturn = "[000]"; //시간설정 - 등록일을 현재 시각과 비교해서 작으면 현재일로 등록
                strNow = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                strPublishDate = _requestDate;
                if (strPublishDate == "") strPublishDate = strNow;
                if (DateTime.Compare(DateTime.Parse(strNow), DateTime.Parse(strPublishDate)) > 0) strPublishDate = strNow;

                strReturn = "[100]";
                jMain = (JObject)postData["form"]["maintable"];
                jSub = (JObject)postData["form"]["subtables"];
                jFile = (JArray)postData["attachlist"];
                //jImg = (JArray)postData["imglist"];
                if (jSub != null) iSubTableCount = jSub.Count;

                if (postData["oid"].ToString() != "" && postData["oid"].ToString() != "0") iOId = Convert.ToInt32(postData["oid"].ToString());

                strReturn = "[200]";
                if (jMain.ContainsKey("DOC_NUMBER") && jMain["DOC_NUMBER"].ToString() == "")
                {
                    jMain["STATUS_VALUE"] = "1";   //결재 미적용
                }

                if (_xfAlias == "ecnplan") //2015-07-10
                {
                    strReturn = "[300]";
                    if (jMain.Count > 0)
                    {
                        if (jMain.ContainsKey("WTDT")) jMain["WTDT"] = strNow;

                        if (jMain.ContainsKey("MFDT"))
                        {
                            jMain["MFDT"] = strNow;
                            strEcnType = "A"; //승인자
                        }

                        if (jMain.ContainsKey("APVRSTATUS") && jMain["APVRSTATUS"].ToString() == "7") //2019-10-15 승인경우만 완료일자 설정
                        {
                            if (jMain.ContainsKey("CODT")) jMain["CODT"] = strNow;
                        }
                    }

                    strReturn = "[310]";
                    if (jSub != null && jSub.Count > 0)
                    {
                        foreach (JObject n in (JArray)jSub["subtable1"])
                        {
                            if (n.ContainsKey("WTDT")) n["WTDT"] = strNow;
                            if (n.ContainsKey("MFDT")) n["MFDT"] = strNow;

                            strEcnType = "P"; //담당부서원 업무계획 등록 경우
                        }
                    }
                }
                //ResponseText(":::ftable=>" + _formID + "::::FORM==>" + oFormInfo.OuterXml); return;

                if (jFile != null && jFile.Count > 0)
                {
                    strReturn = "[400]";
                    //AttachInfo(cn, command, ref oFileInfo);
                    AttachmentsHandler attachHdr = new AttachmentsHandler();
                    svcRt = attachHdr.TempToStorage(Convert.ToInt32(Session["DNID"]), _xfAlias, jFile, null, "");
                    if (svcRt.ResultCode != 0)
                    {
                        throw new Exception(svcRt.ResultMessage);
                    }
                    else
                    {
                        jFile = (JArray)svcRt.ResultDataDetail["FileInfo"];
                    }
                    attachHdr = null;
                    //ResponseText(oFileInfo.OuterXml); return;

                    strReturn = "[410]";
                    //2014-01-20 첨부파일 정보 양식 필드에 넣는 경우
                    foreach (JObject j in jFile)
                    {
                        if (j.ContainsKey("fld") && j["fld"].ToString() != "")
                        {
                            if (j["fld"].ToString().IndexOf(";") > 0)
                            {
                                //하위테이블 필드에서 찾기 : 필드명 + 하위테이블번호 + row 번호 (2015-03-26)
                                string[] vFld = j["fld"].ToString().Split(';');
                                if (jSub.ContainsKey("subtable" + vFld[1]))
                                {
                                    foreach (JObject o in jSub["subtable" + vFld[1]])
                                    {
                                        if (o["ROWSEQ"].ToString() == vFld[2])
                                        {
                                            o[vFld[0]] = j["filename"].ToString() + ";" + j["savedname"].ToString(); break;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                //메인테이블 필드에서 찾기
                                if (jMain.ContainsKey(j["fld"].ToString())) jMain[j["fld"].ToString()] = j["filename"].ToString() + ";" + j["savedname"].ToString();

                            }
                        }
                    }
                }

                strReturn = "[500]";
                CvtTextToNumeric(command, ref jMain);

                //ResponseText(" * string->" + oMainTable.OuterXml);
                //ResponseText(" * sub->" + oFormInfo.SelectSingleNode("subtables").OuterXml);
                //return;

                strReturn = "[600]"; //"양식 저장 및 프로세스 처리";
                using (BSL.FlowBiz.EApproval ea = new EApproval())
                {
                    svcRt = ea.RegisterFormNotEA(Session["CompanyCode"].ToString(), command, _xfAlias, _formID, iSubTableCount, _msgID, postData, strPublishDate);
                }

                if (svcRt.ResultCode == 0)
                {
                    if (_xfAlias == "ecnplan" && strEcnType != "") //2019-10-15 ECN업무처리계획서 후속 작업
                    {
                        strReturn = "[700]";
                        using (DAL.InterfaceDac.InterfaceDac ifDac = new DAL.InterfaceDac.InterfaceDac())
                        {
                            ifDac.SetECNFlag(strEcnType, _xfAlias, Convert.ToInt32(Session["URID"]), Convert.ToInt32(_msgID), _workNotice);
                        }
                    }

                    strReturn = "OK";
                }
                else strReturn = svcRt.ResultMessage;
            }
            catch (Exception ex)
            {
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "RegisterFormNotEA");
                //strReturn = "ERROR :=> " + strReturn;// +Environment.NewLine + ex.Message;
                //ResponseText(strReturn);
                strReturn += ex.Message;
            }
            finally
            {
            }
            return strReturn;
        }

        /// <summary>
        /// DB 필드가 숫자인 경우 노드 값을 숫자 형태로 변경
        /// </summary>
        /// <param name="data"></param>
        private void CvtTextToNumeric(string command, ref JObject data)
        {
            if (this._xfAlias == "tooling")
            {
                string[] vNumericField = "PRODUCTION_COST,CAVITY,BUYER_ID,BUYER_SITEID,MAKE_SUPPLIER_ID,MAKE_SUPPLIER_SITEID,MASS,MATERIAL_MASS,INJECTION_CAPA,SHOT,EXPIRATION_SHOT,TEST_PLACE_ID,TEST_PLACE_SITEID,STORE_PLACE_ID,STORE_PLACE_SITEID,OWNER_ID,OWNER_SITEID,SALES_COST,RETRIEVAL_COST,DOC_OID,EXCHANGE_USD,LASTTRYNO,APPLY_FLAG,STATUS_VALUE,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,PrevWork,CAVITYA,ABLCAVITYA,ABLCAVITY,RUNNERCNT,HOTRUNNERCNT,PRODHR,CYCLETIME".Split(',');
                foreach (var j in data)
                {
                    for (int i = 0; i < vNumericField.Length; i++)
                    {
                        if (j.Key == vNumericField[i])
                        {
                            if (j.Value.ToString().Trim() == "")
                            {
                                data[j.Key] = "0";
                            }
                            else
                            {
                                data[j.Key] = data[j.Key].ToString().Replace(",", "");
                            }
                            break;
                        }
                    }
                    if (command == "edit") data[j.Key] = data[j.Key].ToString().Replace("'", "''");
                }
            }
        }
        #endregion

        #region [기타 함수]
        private string SignImg(string companyCode, string logonId)
        {
            string strPath = "/Storage/" + companyCode + "/Sign/" + logonId + ".jpg";
            if (System.IO.File.Exists(Server.MapPath(strPath))) return strPath;
            else return "";
        }

        private string ConvertCommonFieldToNodeValue(JObject info, string fieldName, string publishDate)
        {
            //문서구분,문서명,문서번호,문서등급,보존년한,제목,작성자,사번,작성부서,게시일,외부키1,외부키2
            //msgtype,docname,docnumber,doclevel,keepyear,subject,creator,creatorempno,creatordept,publishdate,externalkey1,externalkey2
            string strReturn = "";
            switch (fieldName.ToLower())
            {
                case "docname":
                case "msgtype":
                case "docnumber":
                case "doclevel":
                case "keepyear":
                case "subject":
                case "externalkey1":
                case "externalkey2":
                    strReturn = info["doc"][fieldName.ToLower()].ToString();
                    break;
                case "publishdate1":
                    strReturn = Convert.ToDateTime(publishDate).ToString("yyyy-MM-dd");
                    break;
                case "publishdate2":
                    strReturn = Convert.ToDateTime(publishDate).ToString("yyyy/MM/dd");
                    break;
                case "publishdate3":
                    strReturn = Convert.ToDateTime(publishDate).ToString("yyyy.MM.dd");
                    break;
                case "creator":
                    strReturn = info["creator"]["user"].ToString();
                    break;
                case "creatorempno":
                    strReturn = info["creator"]["empno"].ToString();
                    break;
                case "creatordept":
                    strReturn = info["creator"]["dept"].ToString();
                    break;
                default:
                    strReturn = "?";
                    break;
            }
            return strReturn;
        }
        #endregion

        #region [변수 할당]
        private void AssignInitCondition(JObject j)
        {
            _mode = j["M"].ToString();

            _xfAlias = j.ContainsKey("xfalias") ? j["xfalias"].ToString() : "";
            if (_xfAlias == "") _xfAlias = "ea"; //2011-08-23 추가:결재양식외의 양식(금형대장 등)을 위해

            if (!j.ContainsKey("wid")) _workItemID = "";
            else _workItemID = j["wid"].ToString();

            if (!j.ContainsKey("ss")) _signStatus = "";
            else _signStatus = j["ss"].ToString();

            if (!j.ContainsKey("rd")) _requestDate = "";
            else _requestDate = j["rd"].ToString();

            if (j.ContainsKey("biz"))
            {
                if (j["biz"]["processid"] == null) _processID = "";
                else _processID = j["biz"]["processid"].ToString();

                if (j["biz"]["formid"] == null) _formID = "";
                else _formID = j["biz"]["formid"].ToString();

                if (j["biz"]["oid"] == null) _oID = "";
                else _oID = j["biz"]["oid"].ToString();

                if (j["biz"]["appid"] == null) _msgID = "0";
                else _msgID = j["biz"]["appid"].ToString();

                if (j["biz"]["pos"] == null) _posID = "";
                else _posID = j["biz"]["pos"].ToString();

                if (j["biz"]["biz"] == null) _bizRole = "";
                else _bizRole = j["biz"]["biz"].ToString();

                if (j["biz"]["act"] == null) _actRole = "";
                else _actRole = j["biz"]["act"].ToString();

                if (j["biz"]["prevwork"] == null) _workNotice = "";
                else _workNotice = j["biz"]["prevwork"].ToString();
                if (_workNotice == "") _workNotice = "0";   //2011-08-23 작업연결 위해 추가
            }
            else
            {
                _formID = j.ContainsKey("formid") ? j["formid"].ToString() : "";
                _oID = j.ContainsKey("oid") ? j["oid"].ToString() : "";
                _msgID = j.ContainsKey("appid") ? j["appid"].ToString() : "";
                _workNotice = j.ContainsKey("wnid") ? j["wnid"].ToString() : "";
                if (_workNotice == "") _workNotice = "0";
            }

            if (j.ContainsKey("doc"))
            {
                if (j["doc"]["key1"] == null) _externalKey1 = "";
                else _externalKey1 = j["doc"]["key1"].ToString();

                if (j["doc"]["key2"] == null) _externalKey2 = "";
                else _externalKey2 = j["doc"]["key2"].ToString();
            }
        }
        #endregion
    }
}