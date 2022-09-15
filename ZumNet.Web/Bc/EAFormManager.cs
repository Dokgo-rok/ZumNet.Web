using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml;
using System.Web;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using ZumNet.DAL.FlowDac;
using ZumNet.BSL.FlowBiz;

using ZumNet.Framework.Core;
using ZumNet.Framework.Entities.Flow;
using ZumNet.Framework.Exception;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Bc
{
    public class EAFormManager : global::System.MarshalByRefObject, System.IDisposable
	{
		#region [생성자]
		private string _connectString = "";
		private string _ekpDB = "";
        private string _formDB = "";

        /// <summary>
        /// 
        /// </summary>
        public string ConnectionString
		{
			get { return this._connectString; }
			set { this._connectString = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public EAFormManager() : this("")
		{
		}

		/// <summary>
		/// 
		/// </summary>
		public EAFormManager(string connectionString)
		{
			this._connectString = connectionString;

			if (String.IsNullOrWhiteSpace(connectionString))
			{
				this._connectString = DbConnect.GetString(DbConnect.INITIAL_CATALOG.INIT_CAT_BASE);
			}

			this._ekpDB = Framework.Configuration.ConfigINI.GetValue(Framework.Configuration.Sections.SECTION_DBNAME, Framework.Configuration.Property.INIKEY_DB_BASE);
            this._formDB = Framework.Configuration.ConfigINI.GetValue(Framework.Configuration.Sections.SECTION_DBNAME, Framework.Configuration.Property.INIKEY_DB_FORM);
        }

		/// <summary>
		/// 
		/// </summary>
		public void Dispose()
		{
		}
		#endregion

		#region [신규 양식 불러오기]
		public ServiceResult LoadNewServerForm(string mode, string formID, string oID, string workItemID, string msgID
							, string posID, string bizRole, string actRole, string externalKey1, string externalKey2
							, string tmsInfo, string workNotice, string xfAlias, string tp)
		{
            ServiceResult svcRt = new ServiceResult();

            XFormDefinition xfDef = null;
			//DataSet dsRecord = null;
			DataSet dsWorkNotice = null;    //2011-08-09 연결 작업 양식 데이타 가져오기
			DataRow rowCorp = null;

			EApprovalDac eaDac = null;
			ProcessDac procDac = null;
			WorkList wkList = null;

			DataTable dtOptionInfo = null;
			ArrayList vHistoryInfo = null;

			string[] vEdmInfo = null;
			string strSecurity = "G";//기본 부서 권한
			string strDocLevel = "";
			string strKeepYear = "";
			string strMsgType = ""; //2012-05-09 크레신에서 추가 : 양식별 msgtype 설정
			string strSchemaInfo = "";  //2011-10-24 추가

			string strMsg = "양식 기본 정보 가져오기";
			try
			{
				eaDac = new EApprovalDac(this.ConnectionString);
				procDac = new ProcessDac(this.ConnectionString);
				wkList = new WorkList();

				xfDef = eaDac.GetEAFormData(Convert.ToInt32(HttpContext.Current.Session["DNID"]), formID);
				if (xfDef == null)
				{
					strMsg = "해당 양식 정보를 가져오지 못했습니다!";
				}

				if (xfDef.Selectable == "N" || (workNotice != "" && workNotice != "0")) //2016-05-09 조건추가
				{
					//환경안전사전검토 경우 동일 외부키에 대한 이력 정보가 필요하다.
					//if (xfDef.FormID == "CBD6A685B82E4841BB85959DD9468B2A")
					//{
					//    strMsg = "환경안전 이력 정보 가져오기";
					//    vHistoryInfo = dbMgr.SelectRecordData(cn, _externalKey1, _xfAlias, _formID);
					//}
					if (workNotice != "" && workNotice != "0")
					{
						strMsg = "연결 양식 데이타 가져오기";
						dsWorkNotice = procDac.GetWorkNoticePreAppData(Convert.ToInt64(workNotice), "", "");
					}
				}
				else
				{
					//2016-04-21 추가
					strMsg = "양식 초기 데이타 가져오기";
					dsWorkNotice = procDac.GetWorkNoticePreAppData(0, xfDef.MainTable + ";" + xfDef.FormID, HttpContext.Current.Session["URID"].ToString() + ";" + HttpContext.Current.Session["DeptID"].ToString());
				}

				strMsg = "사업장 정보 가져오기";
				rowCorp = eaDac.RetrieveCorpInfo(Convert.ToInt32(HttpContext.Current.Session["OPGroupID"]));

				strMsg = "양식별 옵션 정보";
				dtOptionInfo = eaDac.GetFormOptionInfo(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfDef.MainTable.Replace("FORM_", ""));

				strMsg = "스키마 정보";
				strSchemaInfo = wkList.GetSchemaInfo(xfDef.ProcessID, null, bizRole);   //2011-10-24 추가

				//선도소프트에서 적용 => 이후 적용
				if (xfDef.Reserved2 != "")
				{
					vEdmInfo = xfDef.Reserved2.Split(';');
					strMsgType = vEdmInfo[0];   //2012-05-09 추가
					strSecurity = vEdmInfo[1];
					strKeepYear = vEdmInfo[2];
					strDocLevel = vEdmInfo[3];
				}
				if (strSecurity == "") strSecurity = "G";//없으면 기본 부서권한
			}
			catch (Exception ex)
			{
				strMsg += Environment.NewLine + ex.Message;
				ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, strMsg);

                svcRt.ResultCode = -1;
                svcRt.ResultMessage = strMsg;

                return svcRt;
            }

			if (xfDef != null)
			{
				XmlDocument xForm = null;
				XmlNode oConfig = null;
				XmlNode oBizInfo = null;
				XmlNode oDocInfo = null;
				XmlNode oCategoryInfo = null;
				XmlNode oCreator = null;
				XmlNode oCurrentInfo = null;    //2011-11-30
				XmlNode oFormInfo = null;
				XmlNode oFileInfo = null;
				XmlNode oLinkedDoc = null; //2011-08-09
				XmlNode oHistoryInfo = null;
				XmlNode oAnotherInfo = null;
				XmlNode oOptionInfo = null;
				XmlNode oSchemaInfo = null; //2011-10-24

				XmlDocument xSubTables = null;
				XmlNode oSubTable = null;

				//StringWriter sw = null;

				try
				{
					strMsg = "XML 필수 값 할당 하기";

					xForm = new XmlDocument();
					xForm.Load(HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath")));

					oConfig = xForm.DocumentElement.SelectSingleNode("//config");
					oBizInfo = xForm.DocumentElement.SelectSingleNode("//bizinfo");
					oDocInfo = xForm.DocumentElement.SelectSingleNode("//docinfo");
					oCategoryInfo = xForm.DocumentElement.SelectSingleNode("//categoryinfo");
					oCreator = xForm.DocumentElement.SelectSingleNode("//creatorinfo");
					oCurrentInfo = xForm.DocumentElement.SelectSingleNode("//currentinfo"); //2011-11-30
					oFormInfo = xForm.DocumentElement.SelectSingleNode("//forminfo");
					oFileInfo = xForm.DocumentElement.SelectSingleNode("//fileinfo");
					oLinkedDoc = xForm.DocumentElement.SelectSingleNode("//linkeddocinfo"); //2011-08-09
					oHistoryInfo = xForm.DocumentElement.SelectSingleNode("//historyinfo");
					oAnotherInfo = xForm.DocumentElement.SelectSingleNode("//anothermsginfo");
					oOptionInfo = xForm.DocumentElement.SelectSingleNode("//optioninfo");
					oSchemaInfo = xForm.DocumentElement.SelectSingleNode("//schemainfo");   //2011-10-24

					strMsg = "XML 값 할당 - 설정정보";
					oConfig.Attributes["mode"].Value = mode;
					oConfig.Attributes["root"].Value = Framework.Configuration.Config.Read("RootFolder"); //22-06-15 추가
                    oConfig.Attributes["js"].Value = xfDef.JsName;
					oConfig.Attributes["css"].Value = xfDef.CssName;
					oConfig.Attributes["html"].Value = xfDef.HtmlFile;
                    oConfig.Attributes["actid"].Value = ""; //2022-06-07 추가
                    oConfig.Attributes["bizrole"].Value = bizRole;
					oConfig.Attributes["actrole"].Value = actRole;
					oConfig.Attributes["companycode"].Value = HttpContext.Current.Session["CompanyCode"].ToString();
					oConfig.Attributes["web"].Value = HttpContext.Current.Session["FrontName"].ToString();  //2010-07-06
					oConfig.InnerXml = "<![CDATA[var json={" + ProcessStateChart.JsonParse() + "}]]>";

					strMsg = "XML 값 할당 - 키정보";
					oBizInfo.Attributes["dnid"].Value = HttpContext.Current.Session["DNID"].ToString();
					oBizInfo.Attributes["processid"].Value = "";
					oBizInfo.Attributes["formid"].Value = xfDef.FormID;
					oBizInfo.Attributes["ver"].Value = xfDef.Version.ToString();
					oBizInfo.Attributes["prevwork"].Value = workNotice;   //2011-08-09
                    oBizInfo.Attributes["inherited"].Value = strSecurity; //2022-0512 추가 (아래 keepyear까지)
                    oBizInfo.Attributes["priority"].Value = "N"; //기본값
                    oBizInfo.Attributes["secret"].Value = "N"; //기본값
                    oBizInfo.Attributes["doclevel"].Value = strDocLevel; //코드값 저장
                    oBizInfo.Attributes["keepyear"].Value = strKeepYear; //코드값 저장

                    strMsg = "XML 값 할당 - 작성자";
					oCreator.SelectSingleNode("name").InnerXml = "<![CDATA[" + HttpContext.Current.Session["URName"].ToString() + "]]>";
					oCreator.SelectSingleNode("empno").InnerXml = HttpContext.Current.Session["EmpID"].ToString();
					oCreator.SelectSingleNode("grade").InnerXml = HttpContext.Current.Session["Grade1"].ToString();
					//oCreator.SelectSingleNode("phone").InnerXml = Session["URName"].ToString();
					oCreator.SelectSingleNode("department").InnerXml = "<![CDATA[" + HttpContext.Current.Session["DeptName"].ToString() + "]]>";
					oCreator.Attributes["uid"].Value = HttpContext.Current.Session["URID"].ToString();
					oCreator.Attributes["account"].Value = HttpContext.Current.Session["LogonID"].ToString();
					oCreator.Attributes["deptid"].Value = HttpContext.Current.Session["DeptID"].ToString();
					oCreator.Attributes["deptcode"].Value = HttpContext.Current.Session["DeptAlias"].ToString();
					oCreator.SelectSingleNode("belong").InnerXml = HttpContext.Current.Session["Belong"].ToString();//2010-12-20 추가, 사이트별로 최상위 조직 또는 법인명을 담기 위해
					oCreator.SelectSingleNode("indate").InnerXml = HttpContext.Current.Session["InDate"].ToString();//2011-05-03 추가, 입사일

					if (rowCorp != null)
					{
						strMsg = "XML 값 할당 - 사업장";
						oCreator.InnerXml += String.Format("<corp><domain>{0}</domain><corpcd>{1}</corpcd><corpname>{2}</corpname><addr>{3}</addr><ceo>{4}</ceo><phone>{5}</phone><homepi>{6}</homepi><logo>{7}</logo><logolarge>{8}</logolarge></corp>"
									, rowCorp["Domain"].ToString(), rowCorp["CompanyCode"].ToString(), rowCorp["CompanyName"].ToString(), rowCorp["Address"].ToString(), rowCorp["CEO"].ToString()
									, rowCorp["RepresentPhone"].ToString(), rowCorp["HomePage"].ToString(), rowCorp["Logo_Small"].ToString(), rowCorp["Logo"].ToString());
					}

					strMsg = "XML 값 할당 - 현로그온사용자";
					oCurrentInfo.SelectSingleNode("name").InnerXml = "<![CDATA[" + HttpContext.Current.Session["URName"].ToString() + "]]>";
					oCurrentInfo.SelectSingleNode("empno").InnerXml = HttpContext.Current.Session["EmpID"].ToString();
					oCurrentInfo.SelectSingleNode("grade").InnerXml = HttpContext.Current.Session["Grade1"].ToString();
					//oCurrentInfo.SelectSingleNode("phone").InnerXml = Session["URName"].ToString();
					oCurrentInfo.SelectSingleNode("department").InnerXml = "<![CDATA[" + HttpContext.Current.Session["DeptName"].ToString() + "]]>";
					oCurrentInfo.Attributes["uid"].Value = HttpContext.Current.Session["URID"].ToString();
					oCurrentInfo.Attributes["account"].Value = HttpContext.Current.Session["LogonID"].ToString();
					oCurrentInfo.Attributes["deptid"].Value = HttpContext.Current.Session["DeptID"].ToString();
					oCurrentInfo.Attributes["deptcode"].Value = HttpContext.Current.Session["DeptAlias"].ToString();
                    oCurrentInfo.Attributes["date"].Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"); //22-09-15 추가
                    oCurrentInfo.SelectSingleNode("belong").InnerXml = "<![CDATA[" + HttpContext.Current.Session["Belong"].ToString() + "]]>";
					oCurrentInfo.SelectSingleNode("indate").InnerXml = HttpContext.Current.Session["InDate"].ToString();

					strMsg = "XML 값 할당 - 공통정보";
					oDocInfo.SelectSingleNode("createdate").InnerXml = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
					oDocInfo.SelectSingleNode("docname").InnerText = xfDef.DocName;
                    oDocInfo.SelectSingleNode("msgtype").InnerText = strMsgType; //22-06-14 추가

                    if (vEdmInfo != null)
					{
						strMsg = "이관정보";
						if (vEdmInfo[1] != "" && vEdmInfo[1] != "0" && vEdmInfo[2] != "" && vEdmInfo[2] != "0")
						{
							DataRow drDocInfo = eaDac.RetrieveDocData(Convert.ToInt16(HttpContext.Current.Session["DNID"]), Convert.ToInt32(vEdmInfo[3]), Convert.ToInt32(vEdmInfo[2]));
							if (drDocInfo != null)
							{
								oDocInfo.SelectSingleNode("doclevel").InnerXml = drDocInfo["DocLevel"].ToString();
								oDocInfo.SelectSingleNode("keepyear").InnerXml = drDocInfo["KeepYear"].ToString();
							}
							drDocInfo = null;
						}

						string strTransferXml = WorkListHelper.ConvertTransferInfoToXml(vEdmInfo[4]);
						if (strTransferXml != "") oCategoryInfo.InnerXml = strTransferXml;
						//ResponseText(oCategoryInfo.InnerXml); return;
					}
                    oDocInfo.SelectSingleNode("externalkey1").InnerXml = StringHelper.SetDataAsCDATASection(externalKey1);
                    oDocInfo.SelectSingleNode("externalkey2").InnerXml = StringHelper.SetDataAsCDATASection(externalKey2);

                    if (xfDef.SubTableCount > 0)
					{
						strMsg = "하위테이블 구성";
						xSubTables = new XmlDocument();
						xSubTables.LoadXml(xfDef.SubTableDef);
						//Response.Write(xfDef.SubTableCount.ToString());
					}

					if (tp != "" && externalKey1 != "")//2015-04-06 아래에서 옮김
					{
						string strBody = CallExternalFormData(tp, xfDef.MainTable.Replace("FORM_", ""), externalKey1, externalKey2, xSubTables, xfDef.SubTableCount);
						//ResponseText("*tp=>" + strBody); return;
						oFormInfo.InnerXml = strBody;
					}

					if (xfDef.Selectable == "N" || (workNotice != "" && workNotice != "0")) //2016-05-09 조건추가
					{
						strMsg = "외부/연결 작업 정보 구성";
						//string strSHEBody = "";
						//string strHistoryBody = "";

						//ResponseText(strMsg); return;
						//strMsg = "aaa";
						//strMsg = CallSHEFormData(cn, ref oFileInfo, ref strSHEBody);
						//ResponseText("strSHEBody : " + strSHEBody); return;
						//if (strMsg != "OK") { ResponseText(strMsg); return; }

						//string strBody = "<maintable>" + strSHEBody + "</maintable>";
						//string strHistory = "";

						//oFormInfo.InnerXml = strBody;

						//if (this._tp != "")
						//{
						//    //2011-10-06 추가
						//    string strBody = CallExternalFormData(cn, xfDef.MainTable.Replace("FORM_", ""));
						//    //ResponseText("*tp=>" + strBody); return;
						//    oFormInfo.InnerXml = strBody;
						//}

						if (dsWorkNotice != null && dsWorkNotice.Tables.Count > 0)
						{
							strMsg = "연결 작업 관련문서 구성";
							string strLinkedXml = WorkListHelper.ConvertLinedDocInfoToXml(dsWorkNotice.Tables[0]);
							if (strLinkedXml != "") oLinkedDoc.InnerXml = strLinkedXml;
							strMsg = "연결 작업 양식 정보 구성";
							dsWorkNotice.Tables.RemoveAt(0);
							oFormInfo.InnerXml = ComposeFormData(dsWorkNotice, xSubTables, xfDef.SubTableCount);
						}
					}
					else
					{
						//2016-04-21 보완
						if (dsWorkNotice != null && dsWorkNotice.Tables.Count > 0)//서브테이블 줄 안 보일때
						{
							strMsg = "양식초기데이타구성";
							oFormInfo.InnerXml = ComposeFormData(dsWorkNotice, xSubTables, xfDef.SubTableCount);
						}
						else if (xfDef.SubTableCount > 0 && xfDef.SubTableDef != String.Empty)
						{
							strMsg = "하위테이블구성";
							if (xSubTables != null)
							{
								StringBuilder sbSubTables = new StringBuilder("<subtables>");
								for (int m = 1; m <= xfDef.SubTableCount; m++)
								{
									oSubTable = xSubTables.DocumentElement.SelectSingleNode("subtable" + m.ToString());
									if (oSubTable != null)
									{
										sbSubTables.AppendFormat("<subtable{0}>", m.ToString());
										for (int n = 1; n <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); n++)
										{
											sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", n.ToString());
										}
										sbSubTables.AppendFormat("</subtable{0}>", m.ToString());
										//if (dt.Rows.Count < Convert.ToInt32(oSubTable.Attributes["cnt"].Value))
										//{
										//}
									}
								}
								sbSubTables.Append("</subtables>");
								oFormInfo.InnerXml = sbSubTables.ToString();
								sbSubTables = null;
							}
						}
					}

					if (dtOptionInfo != null)
					{
						strMsg = "양식 옵션 정보";
						string strOptionInfo = WorkListHelper.ConvertOptionInfoToXml(dtOptionInfo);
						if (strOptionInfo != "") oOptionInfo.InnerXml = strOptionInfo;
					}

					if (vHistoryInfo != null && vHistoryInfo.Count > 0)
					{
						strMsg = "환경안전 이력정보";
						string strAnother = "";
						strMsg = ComposeFormHistoryByExternalKey(eaDac, procDac, vHistoryInfo, 0, 0, ref strAnother);
						if (strMsg != "OK") { throw new Exception(strMsg); }
						oAnotherInfo.InnerXml = strAnother;
						strAnother = "";
					}

					if (oSchemaInfo != null && strSchemaInfo != "")
					{
						strMsg = "스키마정보 구성";
						oSchemaInfo.InnerXml = strSchemaInfo;
					}

                    strMsg = "HTML 변환";
                    string formPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder") + "/" + HttpContext.Current.Session["CompanyCode"].ToString() + "/" + xfDef.XslName);

                    svcRt.ResultDataDetail["DocName"] = xfDef.DocName;
                    svcRt.ResultDataDetail["XForm"] = FormHandler.BindEAFormToJson(xfDef, xForm.DocumentElement.SelectSingleNode("//ph_xform_ea"));
                    svcRt.ResultDataString = FileHelper.ConvertXmlToHtml(xForm.OuterXml, formPath);
				}
				catch (Exception ex)
				{
					strMsg += Environment.NewLine + ex;
                    
                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;
                }
				finally
				{
					if (eaDac != null)
					{
                        eaDac.Dispose();
                        eaDac = null;
					}

					if (procDac != null)
					{
                        procDac.Dispose();
                        procDac = null;
					}

                    if (wkList != null)
                    {
                        wkList.Dispose();
                        wkList = null;
                    }

                    if (dsWorkNotice != null)
					{
						dsWorkNotice.Dispose();
						dsWorkNotice = null;
					}

					//if (dsRecord != null)
					//{
					//    dsRecord.Dispose();
					//    dsRecord = null;
					//}

					if (dtOptionInfo != null)
					{
						dtOptionInfo.Dispose();
						dtOptionInfo = null;
					}

					xfDef = null;
					xForm = null;
					oConfig = null;
					oDocInfo = null;
					oCreator = null;
					oCurrentInfo = null;
					oFormInfo = null;
					oCategoryInfo = null;
					oOptionInfo = null;
					oFileInfo = null;
					oLinkedDoc = null;
					oSchemaInfo = null;

					xSubTables = null;
					oSubTable = null;
					rowCorp = null;
				}
			}
			else
			{
                svcRt.ResultCode = -1;
                svcRt.ResultMessage = "해당 하는 양식이 존재 하지 않습니다!";
            }

            return svcRt;
		}
        #endregion

        #region [읽기 양식 불러오기]
        public ServiceResult LoadServerForm(string mode, string formID, string oID, string workItemID, string msgID
                            , string posID, string bizRole, string actRole, string externalKey1, string externalKey2
                            , string tmsInfo, string workNotice, string xfAlias, string tp)
        {
            ServiceResult svcRt = new ServiceResult();

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;
            //ProcessInstance pi = null;
            WorkItemList wiList = null;
            WorkItem curWI = null;
            Activity curAct = null;            //2011-10-24        

            EApprovalDac eaDac = null;
            ProcessDac procDac = null;
            WorkList wkList = null;
            EApproval eaBiz = null;

            DataSet dsForm = null;
            DataSet dsAttachFile = null;
            DataSet dsTransfer = null;
            DataSet dsLinkedDoc = null;
            DataSet dsRecord = null;
            DataTable dtOptionInfo = null;
            DataSet dsExternalInfo = null;
            ArrayList vHistoryInfo = null;

            DataRow rowCorp = null;
            DataTable dtAttrList = null;   //2011-11-01
            string[] vEdmInfo = null;   //2012-05-09 추가

            string strSchemaInfo = "";  //2011-10-24
            string strCurrentPartID = "";

            string strMsg = "양식 기본 정보 가져오기";
            try
            {
                eaDac = new EApprovalDac(this.ConnectionString);
                procDac = new ProcessDac(this.ConnectionString);
                wkList = new WorkList();
                eaBiz = new EApproval();

                //2014-02-27 열람권한체크 추가
                if (!eaBiz.CheckAppAcl(xfAlias, Convert.ToInt32(msgID), Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(HttpContext.Current.Session["DeptID"]))) 
                {
                    strMsg = "열람 권한이 없습니다!"; //throw new Exception("열람 권한이 없습니다!");
                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;

                    return svcRt; //22-07-15 오류 아닌 알림으로 변경
                } 

                strMsg = "양식 공통 데이타 가져오기";
                xfInst = eaDac.SelectXFMainEntity(xfAlias, Convert.ToInt32(msgID));

                if (xfInst == null) throw new Exception("해당하는 양식이 존재 하지 않습니다!");

                strMsg = "양식 기본 정보 가져오기";
                xfDef = eaDac.GetEAFormData(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfInst.FormID);

                strMsg = "양식 메인 테이블 데이타 가져오기";
                dsForm = eaDac.SelectFormData(this._formDB, Convert.ToInt32(msgID), xfDef.MainTable, xfDef.Version, xfDef.SubTableCount);

                //if (xfInst.ExternalKey1 != "") //2016-04-27 전체 양식 대상으로 변경
                //{
                strMsg = "양식별 외부 정보 가져오기";
                dsExternalInfo = eaDac.SelectExternalData(this._formDB, this._ekpDB, Convert.ToInt32(msgID), 0, xfInst.FormID, xfDef.MainTable, xfDef.Version, xfInst.ExternalKey1);
                //}

                if (xfDef.Selectable == "N")
                {
                    //strMsg = "양식별 이력 데이타 가져오기";
                    //dsRecord = dbMgr.SelectHistoryData(cn, _formDB, Convert.ToInt32(this._msgID), xfDef.MainTable, xfDef.Version);

                    ////환경안전사전검토 경우 동일 외부키에 대한 이력 정보가 필요하다.
                    //if (xfDef.FormID == "CBD6A685B82E4841BB85959DD9468B2A")
                    //{
                    //    strMsg = "환경안전 이력 정보 가져오기";
                    //    vHistoryInfo = dbMgr.SelectRecordData(cn, _externalKey1, _xfAlias, xfDef.FormID);
                    //}
                }

                strMsg = "첨부파일 가져오기";
                if (xfInst.HasAttachFile != "0")
                {
                    dsAttachFile = eaDac.SelectAttachFile(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfAlias, xfInst.MessageID);
                }

                strMsg = "이관정보 가져오기";
                if (xfInst.Transfer == "Y")
                {
                    dsTransfer = eaDac.SelectXFormTransfer(xfAlias, xfInst.MessageID.ToString());
                }

                strMsg = "관련문서 가져오기";
                if (xfInst.LinkedMsg == "Y")
                {
                    dsLinkedDoc = eaDac.SelectLinkedDoc(xfAlias, xfInst.MessageID.ToString());
                }
                //this._docStatus = xfInst.DocStatus;

                strMsg = "편집모드 정보 가져오기";
                if (mode == "edit" && xfDef.Reserved2 != "")
                {
                    vEdmInfo = xfDef.Reserved2.Split(';');
                    xfInst.MsgType = vEdmInfo[0];   //2012-05-09 추가
                    xfInst.Inherited = vEdmInfo[1];
                    xfInst.KeepYear = (vEdmInfo[2] == "") ? 0 : Convert.ToInt32(vEdmInfo[2]);
                    xfInst.DocLevel = (vEdmInfo[3] == "") ? 0 : Convert.ToInt32(vEdmInfo[3]);
                }

                //strMsg = "프로세스 기본 정보 가져오기";
                //pi = processDB.SelectProcessInstance(cn, Convert.ToInt32(this._msgID), this._xfAlias);
                //if (this._oID == "") this._oID = pi.OID.ToString();
                //this._docStatus = pi.State.ToString();

                strMsg = "참여자 목록 가져오기";
                wiList = procDac.SelectWorkItems(Convert.ToInt32(msgID), xfAlias);
                if (wiList != null)
                {
                    if (workItemID != "")
                    {
                        curWI = wiList.Find(workItemID);
                    }
                    else
                    {
                        foreach (WorkItem wi in wiList.Items)
                        {
                            if ((wi.State == (int)ProcessStateChart.WorkItemState.InActive)
                                && (wi.ParticipantID == HttpContext.Current.Session["URID"].ToString())
                                && (DateTime.Compare(Convert.ToDateTime(wi.ReceivedDate), DateTime.Now) <= 0))
                            {
                                workItemID = wi.WorkItemID;
                                curWI = wi;
                            }
                        }
                    }
                }

                if (curWI != null)
                {
                    if (oID == "") oID = curWI.OID.ToString();
                    if (bizRole == "") bizRole = curWI.BizRole;
                    if (actRole == "") actRole = curWI.ActRole;
                    if (curWI.State == (int)ProcessStateChart.WorkItemState.InActive)
                    {
                        strCurrentPartID = curWI.ParticipantID;
                        //외부시스템에서 재기안 할 경우 k2값이 변경된다.
                        if (curWI.ActRole == "__ri") xfInst.ExternalKey2 = externalKey2;
                    }
                    curAct = procDac.GetProcessActivity(curWI.ActivityID);    //2011-10-24
                }

                strMsg = "ProcessAttribute 가져오기";
                if (oID != "" && oID != "0") dtAttrList = procDac.SelectProcessInstanceAttribute(Convert.ToInt32(oID), "");

                if (mode == "edit")
                {
                    strMsg = "사업장 정보 가져오기";
                    rowCorp = eaDac.RetrieveCorpInfo(Convert.ToInt32(HttpContext.Current.Session["OPGroupID"]));
                }
                //ResponseText("AAA=>" + xfDef.MainTable);
                //if (curWI != null && this._actRole == "__r" && xfDef.MainTable == "FORM_NEWPRODUCTSTOP")
                //{   
                strMsg = "재기안자가 양식 옵션 정보 가져오기";//2010-09-10 크레신 => 2010-12-26 읽기 양식에서 가져오기로 변경
                dtOptionInfo = eaDac.GetFormOptionInfo(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfDef.MainTable.Replace("FORM_", ""));
                //}

                strMsg = "스키마 정보";
                strSchemaInfo = wkList.GetSchemaInfo(xfDef.ProcessID, curAct, bizRole);   //2011-10-24 추가

            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, strMsg);

                svcRt.ResultCode = -1;
                svcRt.ResultMessage = strMsg;

                return svcRt;
            }

            if (xfInst != null)
            {
                XmlDocument xForm = null;
                XmlNode oConfig = null;
                XmlNode oBizInfo = null;
                XmlNode oCategoryInfo = null;
                XmlNode oCreator = null;
                XmlNode oCurrentInfo = null;    //2011-11-30
                XmlNode oDocInfo = null;
                XmlNode oFormInfo = null;
                XmlNode oFileInfo = null;
                XmlNode oLinkedDoc = null;
                XmlNode oProcessInfo = null;
                XmlNode oHistoryInfo = null;
                XmlNode oAnotherInfo = null;
                XmlNode oOptionInfo = null;
                XmlNode oChartInfo = null;
                XmlNode oSchemaInfo = null; //2011-10-24

                XmlDocument xSubTables = null;
                XmlNode oSubTable = null;

                try
                {
                    strMsg = "XML 객체 생성";

                    xForm = new XmlDocument();
                    xForm.Load(HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath")));

                    oConfig = xForm.DocumentElement.SelectSingleNode("//config");
                    oBizInfo = xForm.DocumentElement.SelectSingleNode("//bizinfo");
                    oCategoryInfo = xForm.DocumentElement.SelectSingleNode("//categoryinfo");
                    oDocInfo = xForm.DocumentElement.SelectSingleNode("//docinfo");
                    oCreator = xForm.DocumentElement.SelectSingleNode("//creatorinfo");
                    oCurrentInfo = xForm.DocumentElement.SelectSingleNode("//currentinfo"); //2011-11-30
                    oFormInfo = xForm.DocumentElement.SelectSingleNode("//forminfo");
                    oFileInfo = xForm.DocumentElement.SelectSingleNode("//fileinfo");
                    oLinkedDoc = xForm.DocumentElement.SelectSingleNode("//linkeddocinfo");
                    oProcessInfo = xForm.DocumentElement.SelectSingleNode("//processinfo");
                    oHistoryInfo = xForm.DocumentElement.SelectSingleNode("//historyinfo");
                    oAnotherInfo = xForm.DocumentElement.SelectSingleNode("//anothermsginfo");
                    oOptionInfo = xForm.DocumentElement.SelectSingleNode("//optioninfo");
                    oChartInfo = xForm.DocumentElement.SelectSingleNode("//chartinfo");
                    oSchemaInfo = xForm.DocumentElement.SelectSingleNode("//schemainfo");   //2011-10-24

                    strMsg = "XML 값 할당 - 설정정보";
                    oConfig.Attributes["mode"].Value = mode;
                    oConfig.Attributes["root"].Value = Framework.Configuration.Config.Read("RootFolder");
                    oConfig.Attributes["js"].Value = xfDef.JsName;
                    oConfig.Attributes["css"].Value = xfDef.CssName;
                    oConfig.Attributes["html"].Value = xfDef.HtmlFile;
                    oConfig.Attributes["partid"].Value = strCurrentPartID;
                    oConfig.Attributes["actid"].Value = curAct != null ? curAct.ActivityID : ""; //2022-06-07 추가
                    oConfig.Attributes["bizrole"].Value = bizRole;
                    oConfig.Attributes["actrole"].Value = actRole;
                    oConfig.Attributes["wid"].Value = workItemID; //2012-02-13 추가 (workitemid가 있는 경우, 다중부서내 동일 결재자가 존재할 경우 필요)
                    oConfig.Attributes["companycode"].Value = HttpContext.Current.Session["CompanyCode"].ToString();
                    oConfig.Attributes["web"].Value = HttpContext.Current.Session["FrontName"].ToString();  //2010-07-06
                    oConfig.InnerXml = "<![CDATA[var json={" + ProcessStateChart.JsonParse() + "}]]>";

                    strMsg = "XML 값 할당 - 키정보";
                    oBizInfo.Attributes["dnid"].Value = HttpContext.Current.Session["DNID"].ToString();
                    oBizInfo.Attributes["processid"].Value = xfDef.ProcessID.ToString();
                    oBizInfo.Attributes["formid"].Value = xfInst.FormID;
                    oBizInfo.Attributes["ver"].Value = xfDef.Version.ToString();
                    oBizInfo.Attributes["oid"].Value = oID;
                    oBizInfo.Attributes["msgid"].Value = msgID;
                    oBizInfo.Attributes["inherited"].Value = xfInst.Inherited;
                    oBizInfo.Attributes["priority"].Value = xfInst.Priority;
                    oBizInfo.Attributes["secret"].Value = xfInst.Secret;
                    oBizInfo.Attributes["docstatus"].Value = xfInst.DocStatus;
                    oBizInfo.Attributes["doclevel"].Value = xfInst.DocLevel.ToString(); //코드값 저장
                    oBizInfo.Attributes["keepyear"].Value = xfInst.KeepYear.ToString(); //코드값 저장

                    //oBizInfo.Attributes["tms"].Value = xfInst.Tms;

                    strMsg = "XML 값 할당 - 작성자";
                    oCreator.SelectSingleNode("name").InnerXml = "<![CDATA[" + xfInst.Creator + "]]>";
                    oCreator.SelectSingleNode("empno").InnerXml = xfInst.CreatorEmpNo;
                    oCreator.SelectSingleNode("grade").InnerXml = xfInst.CreatorGrade;
                    oCreator.SelectSingleNode("phone").InnerXml = xfInst.CreatorPhone;
                    oCreator.SelectSingleNode("department").InnerXml = "<![CDATA[" + xfInst.CreatorDept + "]]>";
                    oCreator.Attributes["uid"].Value = xfInst.CreatorID.ToString();
                    oCreator.Attributes["account"].Value = xfInst.CreatorCN;
                    oCreator.Attributes["deptid"].Value = xfInst.CreatorDeptID.ToString();
                    oCreator.Attributes["deptcode"].Value = xfInst.CreatorDeptCode;

                    if (rowCorp != null)
                    {
                        strMsg = "XML 값 할당 - 사업장";
                        oCreator.InnerXml += String.Format("<corp><domain>{0}</domain><corpcd>{1}</corpcd><corpname>{2}</corpname><addr>{3}</addr><ceo>{4}</ceo><phone>{5}</phone><homepi>{6}</homepi><logo>{7}</logo><logolarge>{8}</logolarge></corp>"
                                    , rowCorp["Domain"].ToString(), rowCorp["CompanyCode"].ToString(), rowCorp["CompanyName"].ToString(), rowCorp["Address"].ToString(), rowCorp["CEO"].ToString()
                                    , rowCorp["RepresentPhone"].ToString(), rowCorp["HomePage"].ToString(), rowCorp["Logo_Small"].ToString(), rowCorp["Logo"].ToString());
                    }

                    strMsg = "XML 값 할당 - 현로그온사용자";
                    oCurrentInfo.SelectSingleNode("name").InnerXml = "<![CDATA[" + HttpContext.Current.Session["URName"].ToString() + "]]>";
                    oCurrentInfo.SelectSingleNode("empno").InnerXml = HttpContext.Current.Session["EmpID"].ToString();
                    oCurrentInfo.SelectSingleNode("grade").InnerXml = HttpContext.Current.Session["Grade1"].ToString();
                    //oCurrentInfo.SelectSingleNode("phone").InnerXml = Session["URName"].ToString();
                    oCurrentInfo.SelectSingleNode("department").InnerXml = "<![CDATA[" + HttpContext.Current.Session["DeptName"].ToString() + "]]>";
                    oCurrentInfo.Attributes["uid"].Value = HttpContext.Current.Session["URID"].ToString();
                    oCurrentInfo.Attributes["account"].Value = HttpContext.Current.Session["LogonID"].ToString();
                    oCurrentInfo.Attributes["deptid"].Value = HttpContext.Current.Session["DeptID"].ToString();
                    oCurrentInfo.Attributes["deptcode"].Value = HttpContext.Current.Session["DeptAlias"].ToString();
                    oCurrentInfo.Attributes["date"].Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"); //22-09-15 추가
                    oCurrentInfo.SelectSingleNode("belong").InnerXml = "<![CDATA[" + HttpContext.Current.Session["Belong"].ToString() + "]]>";
                    oCurrentInfo.SelectSingleNode("indate").InnerXml = HttpContext.Current.Session["InDate"].ToString();

                    strMsg = "XML 값 할당 - 공통정보";
                    oDocInfo.SelectSingleNode("docname").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.DocName);
                    oDocInfo.SelectSingleNode("msgtype").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.MsgType);
                    oDocInfo.SelectSingleNode("docnumber").InnerXml = xfInst.DocNumber;

                    if (xfInst.DocLevel > 0 && xfInst.KeepYear > 0)
                    {
                        DataRow drDocInfo = eaDac.RetrieveDocData(Convert.ToInt16(HttpContext.Current.Session["DNID"]), xfInst.DocLevel, xfInst.KeepYear);
                        if (drDocInfo != null)
                        {
                            oDocInfo.SelectSingleNode("doclevel").InnerXml = drDocInfo["DocLevel"].ToString();
                            oDocInfo.SelectSingleNode("keepyear").InnerXml = drDocInfo["KeepYear"].ToString();
                        }
                        drDocInfo = null;
                    }

                    oDocInfo.SelectSingleNode("subject").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Subject);
                    oDocInfo.SelectSingleNode("createdate").InnerXml = xfInst.CreateDate;
                    oDocInfo.SelectSingleNode("publishdate").InnerXml = xfInst.PublishDate;
                    oDocInfo.SelectSingleNode("expireddate").InnerXml = xfInst.ExpiredDate;
                    oDocInfo.SelectSingleNode("externalkey1").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.ExternalKey1);
                    oDocInfo.SelectSingleNode("externalkey2").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.ExternalKey2);
                    oDocInfo.SelectSingleNode("reserved1").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Reserved1);
                    oDocInfo.SelectSingleNode("reserved2").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Reserved2);

                    //ResponseText("origin->" + oDocInfo.SelectSingleNode("externalkey2").InnerXml);
                    //ResponseText("new->" + this._externalKey2 + Environment.NewLine);
                    //xfInst.ExternalKey2 = this._externalKey2;
                    //ResponseText("renew->" + xfInst.ExternalKey2);
                    //return;

                    strMsg = "XML 값 할당 - 첨부파일";
                    if (xfInst.HasAttachFile != "0" && dsAttachFile != null)
                    {
                        //ResponseText("file->" + dsAttachFile.GetXml()); return;
                        string strFileXml = WorkListHelper.ConvertFileInfoToXml(dsAttachFile.Tables[0]);
                        if (strFileXml != "") oFileInfo.InnerXml = strFileXml;
                    }

                    strMsg = "XML 값 할당 - 이관정보";
                    string strTransferXml = "";
                    if (xfInst.Transfer == "Y" && dsTransfer != null)
                    {
                        strTransferXml = WorkListHelper.ConvertTransferInfoToXml(dsTransfer.Tables[0]);
                    }
                    else
                    {
                        //2012-05-09 추가
                        if (mode == "edit" && vEdmInfo != null)
                        {
                            strTransferXml = WorkListHelper.ConvertTransferInfoToXml(vEdmInfo[4]);
                        }
                    }
                    if (strTransferXml != "") oCategoryInfo.InnerXml = strTransferXml;

                    strMsg = "XML 값 할당 - 관련문서";
                    if (xfInst.LinkedMsg == "Y" && dsLinkedDoc != null)
                    {
                        string strLinkedXml = WorkListHelper.ConvertLinedDocInfoToXml(dsLinkedDoc.Tables[0]);
                        if (strLinkedXml != "") oLinkedDoc.InnerXml = strLinkedXml;
                    }

                    strMsg = "XML 값 할당 - 양식정보";
                    if ((xfDef.SubTableCount > 0) && (xfDef.SubTableDef != String.Empty))
                    {
                        xSubTables = new XmlDocument();
                        xSubTables.LoadXml(xfDef.SubTableDef);
                    }

                    strMsg = "XML 값 할당 - 옵션정보";
                    if (oOptionInfo != null && (dtOptionInfo != null || dsExternalInfo != null))
                    {
                        string strOption = "";
                        string strExternal = "";
                        string strExternal2 = ""; //2016-06-17 추가
                        if (dsExternalInfo != null && dsExternalInfo.Tables.Count > 0)
                        {
                            strExternal = WorkListHelper.ConvertOptionExternalInfoToXml(dsExternalInfo.Tables[0]);
                            //if (dsExternalInfo.Tables.Count > 1) strExternal2 = ConvertOptionExternalInfoToXml2(dsExternalInfo.Tables[1]); //2016-06-17 추가 -> 추후사용
                        }
                        if (dtOptionInfo != null)
                        {
                            //if (curWI != null && this._actRole == "__r" && xfDef.MainTable == "FORM_NEWPRODUCTSTOP")
                            //{
                            //    strOption = ConvertOptionInfoToXml(dtOptionInfo);
                            //}
                            //else
                            //{
                            //    //strOption = ConvertOptionExternalInfoToXml(dtOptionInfo);
                            //}
                            strOption = WorkListHelper.ConvertOptionInfoToXml(dtOptionInfo);
                        }
                        if (strExternal != "" || strOption != "" || strExternal2 != "") oOptionInfo.InnerXml = strOption + strExternal + strExternal2;
                        //ResponseText("option : " + strExternal); return;
                    }

                    DataTable dt = null;
                    StringBuilder sbTable = new StringBuilder();
                    StringBuilder sbSubTables = new StringBuilder();
                    sbTable.Append("<maintable>");

                    for (int x = 0; x < dsForm.Tables.Count; x++)
                    {
                        dt = dsForm.Tables[x];
                        if (x == 0)
                        {
                            foreach (DataRow row in dt.Rows)
                            {
                                foreach (DataColumn col in dt.Columns)
                                {
                                    if (col.ColumnName != "MessageID" && row[col.ColumnName].ToString() != "")
                                    {
                                        if (col.ColumnName == "WEBEDITOR")
                                        {
                                            sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, Framework.Web.HtmlHandler.BodyInnerHtml(row[col.ColumnName].ToString()));
                                        }
                                        else
                                        {
                                            sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (x == 1) sbSubTables.Append("<subtables>");
                            sbSubTables.AppendFormat("<subtable{0}>", x.ToString());

                            foreach (DataRow row in dt.Rows)
                            {
                                sbSubTables.Append("<row>");
                                foreach (DataColumn col in dt.Columns)
                                {
                                    if (col.ColumnName != "MessageID" && row[col.ColumnName].ToString() != "")
                                    {
                                        sbSubTables.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                                sbSubTables.Append("</row>");
                            }

                            oSubTable = xSubTables.DocumentElement.SelectSingleNode("subtable" + x.ToString());
                            if (oSubTable != null)
                            {
                                for (int y = dt.Rows.Count + 1; y <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); y++)
                                {
                                    sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", y.ToString());
                                }
                            }

                            sbSubTables.AppendFormat("</subtable{0}>", x.ToString());
                            if (x == dsForm.Tables.Count - 1) sbSubTables.Append("</subtables>");
                        }
                    }

                    //외부 수신함에서 가져온다.
                    string strSHEBody = "";
                    if (xfDef.Selectable == "N")
                    {
                        if ((curWI != null) && (curWI.ActRole == "__ri"))
                        //&& (curWI.State == (int)Phs.BFF.Entities.ProcessStateChart.WorkItemState.InActive))
                        {
                            //ResponseText("C" + xfDef.Selectable); return;
                            //strMsg = CallSHEFormData(cn, ref oFileInfo, ref strSHEBody);
                            //ResponseText(strSHEBody); return;
                            if (strMsg != "OK") { throw new Exception(strMsg); }

                            //입고 및 시운전/공사품질 CHECK Sheet는 재기안시 새로 받아 온다. 
                            if (xfDef.FormID == "770D9C14EFC54AB1A3678EA93B1F30A6")
                            {
                                sbTable = new StringBuilder();
                                sbTable.Append("<maintable>");

                                //ResponseText("table=>" + sbTable.ToString()); return;
                            }
                        }
                    }

                    //ResponseText("ddd : " + sbTable.ToString()); return;
                    strMsg = "양식 구성";
                    if (strSHEBody != null) sbTable.Append(strSHEBody);
                    sbTable.Append("</maintable>");
                    //ResponseText("3 : " + sbTable.ToString()); return;
                    if (sbTable != null) oFormInfo.InnerXml = sbTable.ToString();
                    if (sbSubTables != null) oFormInfo.InnerXml += sbSubTables.ToString();
                    sbTable = null;
                    sbSubTables = null;

                    //ResponseText("sbTable : " + sbTable.ToString()); return;

                    // 환경안전 검토서, 의뢰서 기존 저장된 내용 가져 오기
                    string strHistory = "";
                    if (dsRecord != null)
                    {
                        strMsg = ComposeFormHistory(procDac, dsRecord, Convert.ToInt32(oID), ref strHistory);
                        if (strMsg != "OK") { throw new Exception(strMsg); }

                        //ResponseText("----" + strHistory); return;
                        strMsg = "XML 값 할당 - 이력정보";
                        oHistoryInfo.InnerXml = strHistory;
                        strHistory = "";
                    }

                    if (vHistoryInfo != null && vHistoryInfo.Count > 0)
                    {
                        strMsg = ComposeFormHistoryByExternalKey(eaDac, procDac, vHistoryInfo, Convert.ToInt32(msgID), Convert.ToInt32(oID), ref strHistory);
                        if (strMsg != "OK") { throw new Exception(strMsg); }
                        oAnotherInfo.InnerXml = strHistory;
                        strHistory = "";
                    }

                    strMsg = "XML 값 할당 - CHART 정보";
                    if (oChartInfo != null)
                    {
                        //ResponseText("----" + xfDef.Version.ToString()); return;
                        oChartInfo.InnerXml = WorkListHelper.ConvertChartInfoToXml(xfDef.MainTable, dsForm, xfDef.Version);
                    }

                    strMsg = "XML 값 할당 - 결재정보";
                    oProcessInfo.InnerXml = "<signline><lines>" + WorkListHelper.ConvertWorkItemListToXmlLine(wiList, "view") + "</lines></signline>";//지정반려는 안보임

                    if (dtAttrList != null)
                    {
                        strMsg = "XML 값 할당 - ProcessAttribute정보";
                        oProcessInfo.InnerXml += WorkListHelper.AssignInstanceAttributes(dtAttrList);
                    }

                    //Response.Write(strFormBody);
                    if (oSchemaInfo != null && strSchemaInfo != "")
                    {
                        strMsg = "스키마정보 구성";
                        oSchemaInfo.InnerXml = strSchemaInfo;
                    }

                    strMsg = "HTML 변환";
                    string formPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder") + "/" + HttpContext.Current.Session["CompanyCode"].ToString() + "/" + xfDef.XslName);

                    svcRt.ResultDataDetail["DocName"] = xfDef.DocName;
                    svcRt.ResultDataDetail["XForm"] = FormHandler.BindEAFormToJson(xfDef, xForm.DocumentElement.SelectSingleNode("//ph_xform_ea"));
                    svcRt.ResultDataString = FileHelper.ConvertXmlToHtml(xForm.OuterXml, formPath);
                }
                catch (Exception ex)
                {
                    strMsg += Environment.NewLine + ex;

                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;
                }
                finally
                {
                    if (eaDac != null)
                    {
                        eaDac.Dispose();
                        eaDac = null;
                    }

                    if (procDac != null)
                    {
                        procDac.Dispose();
                        procDac = null;
                    }

                    if (wkList != null)
                    {
                        wkList.Dispose();
                        wkList = null;
                    }

                    if (eaBiz != null)
                    {
                        eaBiz.Dispose();
                        eaBiz = null;
                    }

                    xfDef = null;
                    xfInst = null;
                    //pi = null;
                    wiList = null;
                    curWI = null;

                    if (dsForm != null) { dsForm.Dispose(); dsForm = null; }
                    if (dsAttachFile != null) { dsAttachFile.Dispose(); dsAttachFile = null; }
                    if (dsTransfer != null) { dsTransfer.Dispose(); dsTransfer = null; }
                    if (dsLinkedDoc != null) { dsLinkedDoc.Dispose(); dsLinkedDoc = null; }
                    if (dsRecord != null) { dsRecord.Dispose(); dsRecord = null; }
                    if (dtOptionInfo != null) { dtOptionInfo.Dispose(); dtOptionInfo = null; }
                    if (dsExternalInfo != null) { dsExternalInfo.Dispose(); dsExternalInfo = null; }
                    if (dtAttrList != null) { dtAttrList.Dispose(); dtAttrList = null; }

                    vHistoryInfo = null;

                    xForm = null;
                    oConfig = null;
                    oBizInfo = null;
                    oDocInfo = null;
                    oCreator = null;
                    oCurrentInfo = null;
                    oFormInfo = null;
                    oFileInfo = null;
                    oOptionInfo = null;
                    oSchemaInfo = null;

                    xSubTables = null;
                    oSubTable = null;
                    rowCorp = null;
                }
            }
            else
            {
                svcRt.ResultCode = -1;
                svcRt.ResultMessage = "해당 하는 양식이 존재 하지 않습니다!";
            }
            return svcRt;
        }
        #endregion

        #region [양식본문을 HTML로 내려 주기]
        public ServiceResult LoadHtmlForm(string oID, string msgID, string xfAlias)
        {
            ServiceResult svcRt = new ServiceResult();

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;

            EApproval eaBiz = null;
            string strMsg = "";

            try
            {
                eaBiz = new EApproval();

                //2014-02-27 열람권한체크 추가
                if (!eaBiz.CheckAppAcl(xfAlias, Convert.ToInt32(msgID), Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(HttpContext.Current.Session["DeptID"])))
                {
                    strMsg = "열람 권한이 없습니다!"; //throw new Exception("열람 권한이 없습니다!");
                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;

                    return svcRt; //22-07-15 오류 아닌 알림으로 변경
                }

                using (EApprovalDac eaDac = new EApprovalDac())
                {
                    strMsg = "양식 공통 데이타 가져오기";
                    xfInst = eaDac.SelectXFMainEntity(xfAlias, Convert.ToInt32(msgID));

                    strMsg = "양식 기본 정보 가져오기";
                    xfDef = eaDac.GetEAFormData(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfInst.FormID);
                }

                string strFormSchema = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath"));
                string strFormPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder"));

                strMsg = "본문HTML";
                svcRt = eaBiz.ParsingXFormToHTML(HttpContext.Current.Session["CompanyCode"].ToString(), xfDef, xfInst, Convert.ToInt32(oID), xfAlias
                                , HttpContext.Current.Session["DNID"].ToString(), HttpContext.Current.Session["FrontName"].ToString()
                                , Framework.Configuration.Config.Read("RootFolder"), strFormSchema, strFormPath);
            
                svcRt.ResultDataDetail.Add("DocName", xfInst.DocName);
            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, strMsg);

                svcRt.ResultCode = -1;
                svcRt.ResultMessage = strMsg;
            }

            return svcRt;
        }
        #endregion

        #region [인쇄 양식 불러오기]
        public ServiceResult LoadPrintForm()
        {
            ServiceResult svcRt = new ServiceResult();

            //JObject jBiz = null;
            //JObject jMain = null;
            //JObject jSub = null;
            //JArray jFile = null;
            //JArray jImg = null;

            //XFormDefinition xfDef = null;
            //string strMsg = "";

            //try
            //{
            //}
            //catch (Exception ex)
            //{
            //    strMsg += Environment.NewLine + ex.Message;
            //    ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, strMsg);

            //    svcRt.ResultCode = -1;
            //    svcRt.ResultMessage = strMsg;
            //}
            //finally
            //{
            //    xfDef = null;
            //}
            return svcRt;
        }
        #endregion

        #region [재사용 양식 불러오기]
        public ServiceResult LoadReuseForm(string mode, string formID, string oID, string workItemID, string msgID
                            , string posID, string bizRole, string actRole, string externalKey1, string externalKey2
                            , string tmsInfo, string workNotice, string xfAlias, string tp)
        {
            ServiceResult svcRt = new ServiceResult();

            XFormDefinition xfDef = null;
            XFormInstance xfInst = null;

            EApprovalDac eaDac = null;
            ProcessDac procDac = null;
            WorkList wkList = null;
            EApproval eaBiz = null;

            DataSet dsForm = null;
            DataRow rowCorp = null;
            DataTable dtOptionInfo = null;

            string[] vEdmInfo = null;
            string strSecurity = "G";//기본 부서 권한
            string strDocLevel = "";
            string strKeepYear = "";
            string strMsgType = ""; //2012-05-09 크레신에서 추가 : 양식별 msgtype 설정
            string strSchemaInfo = "";  //2011-10-24 추가

            string strCurrentPartID = "";

            string strMsg = "양식 기본 정보 가져오기";
            try
            {
                eaDac = new EApprovalDac(this.ConnectionString);
                procDac = new ProcessDac(this.ConnectionString);
                wkList = new WorkList();
                eaBiz = new EApproval();

                //2014-02-27 열람권한체크 추가
                if (!eaBiz.CheckAppAcl(xfAlias, Convert.ToInt32(msgID), Convert.ToInt32(HttpContext.Current.Session["URID"]), Convert.ToInt32(HttpContext.Current.Session["DeptID"])))
                {
                    strMsg = "열람 권한이 없습니다!"; //throw new Exception("열람 권한이 없습니다!");
                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;

                    return svcRt; //22-07-15 오류 아닌 알림으로 변경
                }

                strMsg = "양식 공통 데이타 가져오기";
                xfInst = eaDac.SelectXFMainEntity(xfAlias, Convert.ToInt32(msgID));

                if (xfInst == null) throw new Exception("해당하는 양식이 존재 하지 않습니다!");

                strMsg = "양식 기본 정보 가져오기";
                xfDef = eaDac.GetEAFormData(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfInst.FormID);

                strMsg = "양식 메인 테이블 데이타 가져오기";
                dsForm = eaDac.SelectFormData(this._formDB, Convert.ToInt32(msgID), xfDef.MainTable, xfDef.Version, xfDef.SubTableCount);

                strMsg = "사업장 정보 가져오기";
                rowCorp = eaDac.RetrieveCorpInfo(Convert.ToInt32(HttpContext.Current.Session["OPGroupID"]));

                strMsg = "재기안자가 양식 옵션 정보 가져오기";//2010-09-10 크레신 => 2010-12-26 읽기 양식에서 가져오기로 변경
                dtOptionInfo = eaDac.GetFormOptionInfo(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfDef.MainTable.Replace("FORM_", ""));

                strMsg = "스키마 정보";
                strSchemaInfo = wkList.GetSchemaInfo(xfDef.ProcessID, null, "");   //2011-10-24 추가

                //선도소프트에서 적용
                if (xfDef.Reserved2 != "")
                {
                    vEdmInfo = xfDef.Reserved2.Split(';');
                    strMsgType = vEdmInfo[0];   //2012-05-09 추가
                    strSecurity = vEdmInfo[1];
                    strKeepYear = vEdmInfo[2];
                    strDocLevel = vEdmInfo[3];
                }
                //ResponseText(xfDef.Reserved2); return;

                //재사용 문서는 첨부파일, 이관정보, 관련문서, 결재선 등은 사용 안한다.
            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, strMsg);

                svcRt.ResultCode = -1;
                svcRt.ResultMessage = strMsg;

                return svcRt;
            }

            if (xfInst != null)
            {
                XmlDocument xForm = null;
                XmlNode oConfig = null;
                XmlNode oBizInfo = null;
                XmlNode oCategoryInfo = null;
                XmlNode oCreator = null;
                XmlNode oCurrentInfo = null;    //2011-11-30
                XmlNode oDocInfo = null;
                XmlNode oFormInfo = null;
                XmlNode oOptionInfo = null;
                XmlNode oSchemaInfo = null; //2011-10-24

                XmlDocument xSubTables = null;
                XmlNode oSubTable = null;

                try
                {
                    strMsg = "XML 객체 생성";

                    xForm = new XmlDocument();
                    xForm.Load(HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormSchemaPath")));

                    oConfig = xForm.DocumentElement.SelectSingleNode("//config");
                    oBizInfo = xForm.DocumentElement.SelectSingleNode("//bizinfo");
                    oCategoryInfo = xForm.DocumentElement.SelectSingleNode("//categoryinfo");
                    oDocInfo = xForm.DocumentElement.SelectSingleNode("//docinfo");
                    oCreator = xForm.DocumentElement.SelectSingleNode("//creatorinfo");
                    oCurrentInfo = xForm.DocumentElement.SelectSingleNode("//currentinfo"); //2011-11-30
                    oFormInfo = xForm.DocumentElement.SelectSingleNode("//forminfo");
                    oOptionInfo = xForm.DocumentElement.SelectSingleNode("//optioninfo");
                    oSchemaInfo = xForm.DocumentElement.SelectSingleNode("//schemainfo");   //2011-10-24

                    strMsg = "XML 값 할당 - 설정정보";
                    oConfig.Attributes["mode"].Value = "edit";
                    oConfig.Attributes["root"].Value = Framework.Configuration.Config.Read("RootFolder");
                    oConfig.Attributes["js"].Value = xfDef.JsName;
                    oConfig.Attributes["css"].Value = xfDef.CssName;
                    oConfig.Attributes["html"].Value = xfDef.HtmlFile;
                    oConfig.Attributes["partid"].Value = strCurrentPartID;
                    oConfig.Attributes["actid"].Value = ""; //2022-06-07 추가
                    oConfig.Attributes["bizrole"].Value = bizRole;
                    oConfig.Attributes["actrole"].Value = actRole;
                    oConfig.Attributes["wid"].Value = ""; // workItemID; //2012-02-13 추가 (workitemid가 있는 경우)
                    oConfig.Attributes["companycode"].Value = HttpContext.Current.Session["CompanyCode"].ToString();
                    oConfig.Attributes["web"].Value = HttpContext.Current.Session["FrontName"].ToString();  //2010-07-06
                    oConfig.InnerXml = "<![CDATA[var json={" + ProcessStateChart.JsonParse() + "}]]>";

                    strMsg = "XML 값 할당 - 키정보";
                    oBizInfo.Attributes["dnid"].Value = HttpContext.Current.Session["DNID"].ToString();
                    oBizInfo.Attributes["processid"].Value = "";
                    oBizInfo.Attributes["formid"].Value = xfDef.FormID;
                    oBizInfo.Attributes["ver"].Value = xfDef.Version.ToString();
                    oBizInfo.Attributes["prevwork"].Value = workNotice;
                    oBizInfo.Attributes["inherited"].Value = strSecurity; //2022-0512 추가 (아래 keepyear까지)
                    oBizInfo.Attributes["priority"].Value = "N"; //기본값
                    oBizInfo.Attributes["secret"].Value = "N"; //기본값
                    oBizInfo.Attributes["doclevel"].Value = strDocLevel; //코드값 저장
                    oBizInfo.Attributes["keepyear"].Value = strKeepYear; //코드값 저장

                    strMsg = "XML 값 할당 - 작성자";
                    oCreator.SelectSingleNode("name").InnerXml = "<![CDATA[" + HttpContext.Current.Session["URName"].ToString() + "]]>";
                    oCreator.SelectSingleNode("empno").InnerXml = HttpContext.Current.Session["empid"].ToString();
                    oCreator.SelectSingleNode("grade").InnerXml = HttpContext.Current.Session["GRADE1"].ToString();
                    //oCreator.SelectSingleNode("phone").InnerXml = Session["URName"].ToString();
                    oCreator.SelectSingleNode("department").InnerXml = "<![CDATA[" + HttpContext.Current.Session["DeptName"].ToString() + "]]>";
                    oCreator.Attributes["uid"].Value = HttpContext.Current.Session["URID"].ToString();
                    oCreator.Attributes["account"].Value = HttpContext.Current.Session["LogonID"].ToString();
                    oCreator.Attributes["deptid"].Value = HttpContext.Current.Session["DeptID"].ToString();
                    oCreator.Attributes["deptcode"].Value = HttpContext.Current.Session["DeptAlias"].ToString();
                    oCreator.SelectSingleNode("belong").InnerXml = HttpContext.Current.Session["Belong"].ToString();//2010-12-20 추가, 사이트별로 최상위 조직 또는 법인명을 담기 위해
                    oCreator.SelectSingleNode("indate").InnerXml = HttpContext.Current.Session["InDate"].ToString();//2011-05-03 추가, 입사일

                    if (rowCorp != null)
                    {
                        strMsg = "XML 값 할당 - 사업장";
                        oCreator.InnerXml += String.Format("<corp><domain>{0}</domain><corpcd>{1}</corpcd><corpname>{2}</corpname><addr>{3}</addr><ceo>{4}</ceo><phone>{5}</phone><homepi>{6}</homepi><logo>{7}</logo><logolarge>{8}</logolarge></corp>"
                                    , rowCorp["Domain"].ToString(), rowCorp["CompanyCode"].ToString(), rowCorp["CompanyName"].ToString(), rowCorp["Address"].ToString(), rowCorp["CEO"].ToString()
                                    , rowCorp["RepresentPhone"].ToString(), rowCorp["HomePage"].ToString(), rowCorp["Logo_Small"].ToString(), rowCorp["Logo"].ToString());
                    }

                    strMsg = "XML 값 할당 - 현로그온사용자";
                    oCurrentInfo.SelectSingleNode("name").InnerXml = "<![CDATA[" + HttpContext.Current.Session["URName"].ToString() + "]]>";
                    oCurrentInfo.SelectSingleNode("empno").InnerXml = HttpContext.Current.Session["empid"].ToString();
                    oCurrentInfo.SelectSingleNode("grade").InnerXml = HttpContext.Current.Session["GRADE1"].ToString();
                    //oCurrentInfo.SelectSingleNode("phone").InnerXml = Session["URName"].ToString();
                    oCurrentInfo.SelectSingleNode("department").InnerXml = "<![CDATA[" + HttpContext.Current.Session["DeptName"].ToString() + "]]>";
                    oCurrentInfo.Attributes["uid"].Value = HttpContext.Current.Session["URID"].ToString();
                    oCurrentInfo.Attributes["account"].Value = HttpContext.Current.Session["LogonID"].ToString();
                    oCurrentInfo.Attributes["deptid"].Value = HttpContext.Current.Session["DeptID"].ToString();
                    oCurrentInfo.Attributes["deptcode"].Value = HttpContext.Current.Session["DeptAlias"].ToString();
                    oCurrentInfo.Attributes["date"].Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"); //22-09-15 추가
                    oCurrentInfo.SelectSingleNode("belong").InnerXml = "<![CDATA[" + HttpContext.Current.Session["Belong"].ToString() + "]]>";
                    oCurrentInfo.SelectSingleNode("indate").InnerXml = HttpContext.Current.Session["InDate"].ToString();

                    strMsg = "XML 값 할당 - 공통정보";
                    oDocInfo.SelectSingleNode("createdate").InnerXml = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
                    oDocInfo.SelectSingleNode("docname").InnerText = xfDef.DocName;
                    oDocInfo.SelectSingleNode("subject").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Subject);
                    oDocInfo.SelectSingleNode("msgtype").InnerText = strMsgType; //22-06-14 추가

                    if (vEdmInfo != null)
                    {
                        strMsg = "이관정보";
                        if (vEdmInfo[1] != "" && vEdmInfo[1] != "0" && vEdmInfo[2] != "" && vEdmInfo[2] != "0")
                        {
                            DataRow drDocInfo = eaDac.RetrieveDocData(Convert.ToInt16(HttpContext.Current.Session["DNID"]), Convert.ToInt32(vEdmInfo[3]), Convert.ToInt32(vEdmInfo[2]));
                            if (drDocInfo != null)
                            {
                                oDocInfo.SelectSingleNode("doclevel").InnerXml = drDocInfo["DocLevel"].ToString();
                                oDocInfo.SelectSingleNode("keepyear").InnerXml = drDocInfo["KeepYear"].ToString();
                            }
                            drDocInfo = null;
                        }

                        string strTransferXml = WorkListHelper.ConvertTransferInfoToXml(vEdmInfo[4]);
                        if (strTransferXml != "") oCategoryInfo.InnerXml = strTransferXml;
                        //ResponseText(oCategoryInfo.InnerXml); return;
                    }
                    oDocInfo.SelectSingleNode("externalkey1").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.ExternalKey1);
                    oDocInfo.SelectSingleNode("externalkey2").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.ExternalKey2);
                    oDocInfo.SelectSingleNode("reserved1").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Reserved1);
                    oDocInfo.SelectSingleNode("reserved2").InnerXml = StringHelper.SetDataAsCDATASection(xfInst.Reserved2);

                    strMsg = "XML 값 할당 - 양식정보";
                    if (xfDef.SubTableCount > 0 && xfDef.SubTableDef != String.Empty)
                    {
                        xSubTables = new XmlDocument();
                        xSubTables.LoadXml(xfDef.SubTableDef);
                    }

                    strMsg = "XML 값 할당 - 옵션정보";
                    if (oOptionInfo != null && dtOptionInfo != null)
                    {
                        string strOption = "";
                        if (dtOptionInfo != null)
                        {
                            strOption = WorkListHelper.ConvertOptionInfoToXml(dtOptionInfo);
                        }
                        if (strOption != "") oOptionInfo.InnerXml = strOption;
                    }

                    DataTable dt = null;
                    StringBuilder sbTable = new StringBuilder();
                    StringBuilder sbSubTables = new StringBuilder();
                    sbTable.Append("<maintable>");

                    for (int x = 0; x < dsForm.Tables.Count; x++)
                    {
                        dt = dsForm.Tables[x];
                        if (x == 0)
                        {
                            foreach (DataRow row in dt.Rows)
                            {
                                foreach (DataColumn col in dt.Columns)
                                {
                                    if ((col.ColumnName != "MessageID") && (row[col.ColumnName].ToString() != ""))
                                    {
                                        sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (x == 1) sbSubTables.Append("<subtables>");
                            sbSubTables.AppendFormat("<subtable{0}>", x.ToString());

                            foreach (DataRow row in dt.Rows)
                            {
                                sbSubTables.Append("<row>");
                                foreach (DataColumn col in dt.Columns)
                                {
                                    if ((col.ColumnName != "MessageID") && (row[col.ColumnName].ToString() != ""))
                                    {
                                        sbSubTables.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                                sbSubTables.Append("</row>");
                            }

                            oSubTable = xSubTables.DocumentElement.SelectSingleNode("subtable" + x.ToString());
                            if (oSubTable != null)
                            {
                                for (int y = dt.Rows.Count + 1; y <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); y++)
                                {
                                    sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", y.ToString());
                                }
                            }

                            sbSubTables.AppendFormat("</subtable{0}>", x.ToString());
                            if (x == dsForm.Tables.Count - 1) sbSubTables.Append("</subtables>");
                        }
                    }

                    sbTable.Append("</maintable>");
                    if (sbTable != null) oFormInfo.InnerXml = sbTable.ToString();
                    if (sbSubTables != null) oFormInfo.InnerXml += sbSubTables.ToString();
                    sbTable = null;
                    sbSubTables = null;

                    if (oSchemaInfo != null && strSchemaInfo != "")
                    {
                        strMsg = "스키마정보 구성";
                        oSchemaInfo.InnerXml = strSchemaInfo;
                    }

                    strMsg = "HTML 변환";
                    string formPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormFolder") + "/" + HttpContext.Current.Session["CompanyCode"].ToString() + "/" + xfDef.XslName);

                    svcRt.ResultDataDetail["DocName"] = xfDef.DocName;
                    svcRt.ResultDataDetail["XForm"] = FormHandler.BindEAFormToJson(xfDef, xForm.DocumentElement.SelectSingleNode("//ph_xform_ea"));
                    svcRt.ResultDataString = FileHelper.ConvertXmlToHtml(xForm.OuterXml, formPath);

                }
                catch (Exception ex)
                {
                    strMsg += Environment.NewLine + ex;

                    svcRt.ResultCode = -1;
                    svcRt.ResultMessage = strMsg;
                }
                finally
                {
                    if (eaDac != null)
                    {
                        eaDac.Dispose();
                        eaDac = null;
                    }

                    if (procDac != null)
                    {
                        procDac.Dispose();
                        procDac = null;
                    }

                    if (wkList != null)
                    {
                        wkList.Dispose();
                        wkList = null;
                    }

                    if (eaBiz != null)
                    {
                        eaBiz.Dispose();
                        eaBiz = null;
                    }

                    xfDef = null;
                    xfInst = null;

                    if (dsForm != null) { dsForm.Dispose(); dsForm = null; }
                    if (dtOptionInfo != null) { dtOptionInfo.Dispose(); dtOptionInfo = null; }

                    xForm = null;
                    oConfig = null;
                    oBizInfo = null;
                    oDocInfo = null;
                    oCreator = null;
                    oCurrentInfo = null;
                    oFormInfo = null;
                    oOptionInfo = null;
                    oSchemaInfo = null;

                    xSubTables = null;
                    oSubTable = null;
                    rowCorp = null;
                }
            }
            else
            {
                strMsg = " 해당 하는 양식이 존재 하지 않습니다!";
            }

            return svcRt;
        }
        #endregion

        #region [결재이외의 양식(예:금형대장) 불러오기]
        public ServiceResult LoadBFForm(string mode, string xfAlias, string formID, string msgID, string workNotice)
        {
            ServiceResult svcRt = new ServiceResult();

            EApprovalDac eaDac = null;
            ProcessDac procDac = null;

            DataSet dsForm = null;
            DataSet dsFile = null;
            DataTable dtOption = null;
            DataRow rowWorkNotice = null;   //2013-05-10 추가

            string strRelatedId = "";   //2013-05-09 추가 : 관련 결재id, pdm id
            string strAclType = "";     //2013-05-10 추가
            int iOId = 0;

            StringBuilder sbXml = new StringBuilder();
            string strXslPath = "";
            string strMsg = "";

            XmlDocument xForm = null;

            try
            {
                eaDac = new EApprovalDac(this.ConnectionString);
                procDac = new ProcessDac(this.ConnectionString);

                if (msgID != "" && msgID != "0")
                {
                    strMsg = "양식 데이타 가져오기";
                    dsForm = eaDac.SelectFormDataNotEA(msgID, xfAlias, formID);
                    //ResponseText(_msgID + " : " + _xfAlias + " : " + _formID); return;

                    if (dsForm == null || dsForm.Tables.Count == 0)
                    {
                        throw new Exception("해당하는 양식이 존재 하지 않습니다!");
                    }

                    if (xfAlias == "tooling")
                    {
                        iOId = Convert.ToInt32(dsForm.Tables[0].Rows[0]["fiid"]);
                        strRelatedId = dsForm.Tables[0].Rows[0]["DOC_OID"].ToString();
                    }
                    else if (xfAlias == "ecnplan")
                    {
                        //2015-07-08 추가
                        iOId = Convert.ToInt32(dsForm.Tables[0].Rows[0]["ECNID"]);
                        strRelatedId = dsForm.Tables[0].Rows[0]["MessageID"].ToString();
                    }
                    dsFile = eaDac.SelectAttachFile(Convert.ToInt32(HttpContext.Current.Session["DNID"]), xfAlias, iOId);
                }

                strMsg = "양식 옵션 정보";
                dtOption = eaDac.GetFormOptionInfo(Convert.ToInt32(HttpContext.Current.Session["DNID"]), formID);

                if (workNotice != "" && workNotice != "0")
                {
                    rowWorkNotice = procDac.SelectWorkItemNotice(long.Parse(workNotice));
                }

                if (xfAlias == "tooling" && iOId > 0)
                {
                    //권한 설정 ==> 2014-07-28 수정 권한을 모두에게 부여
                    strAclType = "B";
                    //if (Session["Admin"].ToString() == "Y") strAclType = "A";
                    //else if (Session["URID"].ToString() == dsForm.Tables[0].Rows[0]["CREATORID"].ToString()
                    //    || (rowWorkNotice != null && Session["LogonID"].ToString() == rowWorkNotice["PartCode"].ToString())) strAclType = "B";
                    //else if (Session["URID"].ToString() == dsForm.Tables[0].Rows[0]["CHARGE_USER_ID"].ToString()) strAclType = "C";
                    //else strAclType = "";
                }

                strMsg = "기본정보 구성";
                sbXml.AppendFormat("<ph_xform><config mode=\"{0}\" web=\"{1}\" root=\"{2}\" company=\"{3}\" oid=\"{4}\" relid=\"{5}\" acl=\"{6}\" msgid=\"{7}\" formid=\"{8}\" xfalias=\"{9}\" wnid=\"{10}\"></config>"
                            , mode, HttpContext.Current.Session["FrontName"].ToString(), Framework.Configuration.Config.Read("RootFolder"), HttpContext.Current.Session["CompanyCode"].ToString()
                            , iOId.ToString(), strRelatedId, strAclType, msgID, formID, xfAlias, workNotice);
                sbXml.AppendFormat("<current uid=\"{0}\" account=\"{1}\" deptid=\"{2}\" deptcode=\"{3}\" date=\"{4}\">"
                            , HttpContext.Current.Session["URID"].ToString(), HttpContext.Current.Session["LogonID"].ToString()
                            , HttpContext.Current.Session["DeptID"].ToString(), HttpContext.Current.Session["DeptAlias"].ToString(), DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                sbXml.AppendFormat("<name>{0}</name><depart>{1}</depart><belong>{2}</belong></current>"
                            , HttpContext.Current.Session["URName"].ToString(), HttpContext.Current.Session["DeptName"].ToString(), HttpContext.Current.Session["Belong"].ToString());

                strMsg = "양식정보 구성";
                sbXml.Append("<forminfo>");
                sbXml.Append(ComposeFormData(dsForm));
                sbXml.Append("</forminfo>");

                strMsg = "양식 옵션 구성";
                sbXml.Append("<optioninfo>");
                if (dtOption != null) sbXml.Append(WorkListHelper.ConvertOptionInfoToXml(dtOption));
                sbXml.Append("</optioninfo>");

                strMsg = "첨부파일 구성";
                sbXml.Append("<fileinfo>");
                if (dsFile != null) sbXml.Append(WorkListHelper.ConvertFileInfoToXml(dsFile.Tables[0]));
                sbXml.Append("</fileinfo>");

                sbXml.Append("</ph_xform>");

                strMsg = "HTML 변환";
                //strXslPath = Server.MapPath("/" + Application["rootFolderName"].ToString() + "/EA/Forms/HTML/REGISTER_TOOLING.xsl");
                if (xfAlias == "tooling")
                {
                    strXslPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormHtmlPath") + "/REGISTER_TOOLING.xsl");
                    //strReturn = Utility.ConvertXmlToHtml(sbXml.ToString(), strXslPath);
                }
                else if (xfAlias == "ecnplan")
                {
                    strXslPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormHtmlPath") + "/REGISTER_ECNPLAN.xsl");
                }

                xForm = new XmlDocument();
                xForm.LoadXml(sbXml.ToString());

                svcRt.ResultDataDetail["DocName"] = "";
                svcRt.ResultDataDetail["XForm"] = FormHandler.BindNotEAFormToJson(xForm.DocumentElement.SelectSingleNode("//ph_xform"));
                svcRt.ResultDataString = FileHelper.ConvertXmlToHtml(xForm.OuterXml, strXslPath);
            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex;

                svcRt.ResultCode = -1;
                svcRt.ResultMessage = strMsg;
            }
            finally
            {
                //if (cn != null) { cn.Close(); cn.Dispose(); }
                if (dsForm != null) { dsForm.Dispose(); dsForm = null; }
                if (dsFile != null) { dsFile.Dispose(); dsFile = null; }
                if (dtOption != null) { dtOption.Dispose(); dtOption = null; }
                rowWorkNotice = null;

                sbXml = null;
                xForm = null;
            }

            return svcRt;
        }

        /// <summary>
        /// 인쇄 보기
        /// </summary>
        /// <param name="postData"></param>
        private void LoadBFPrintForm()
        {
            
        }
        #endregion

        #region [양식별 본문 정보 가져오기]
        /// <summary>
        /// 외부에서 본문 가져오기 - ERP
        /// </summary>
        /// <param name="tp"></param>
        /// <param name="formTable"></param>
        /// <param name="externalKey1"></param>
        /// <param name="externalKey2"></param>
        /// <returns></returns>
        private string CallExternalFormData(string tp, string formTable, string externalKey1, string externalKey2)
        {
            return CallExternalFormData(tp, formTable, externalKey1, externalKey2, null, 0);
        }

        private string CallExternalFormData(string tp, string formTable, string externalKey1, string externalKey2, XmlDocument subTblDef, int subCnt)
        {
            string strPos = "";
            string strBody = "";
            string strSubTable = ""; //2020-10-07
            StringBuilder sbData = null;
            int iRow = 0;

            ServiceResult svcRt = null;

            try
            {
                if (tp == "HSERP")
                {
                    ////string strUrl = String.Format("http://{0}/{1}/EA/HttpProcess/XFormERP.aspx?k1={2}&k2={3}", HttpContext.Current.Session["FRONTNAME"].ToString(), Application["rootFolderName"].ToString(), this._externalKey1, this._externalKey2);
                    //string strUrl = String.Format("http://{0}/{1}/EA/HttpProcess/XFormERP.asp?k1={2}&k2={3}", HttpContext.Current.Session["FRONTNAME"].ToString(), Application["rootFolderName"].ToString(), this._externalKey1, this._externalKey2);
                    ////strUrl = "http://eip.dongsuh.com/logon/XFormERP.asp";
                    //System.Net.HttpWebRequest HttpWReq = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
                    //System.Net.HttpWebResponse HttpWResp = (System.Net.HttpWebResponse)HttpWReq.GetResponse();
                    //using (System.IO.StreamReader sr = new System.IO.StreamReader(HttpWResp.GetResponseStream()))
                    //{
                    //    strBody = sr.ReadToEnd();
                    //}
                    //HttpWResp.Close();
                    ////strBody = strUrl;

                    ////strBody = "<table><tr><td>ㅁㄹㄴ;ㅗ애ㅑ론ㅇ매롬낼;ㅗㅁㄴㄹ;ㅐ모내ㅑㅇ롬내ㅑ로맨;ㅑㄹ</td></tr></table>";
                    //strBody = "<ERPINFO><![CDATA[" + strBody + "]]></ERPINFO>";
                    ////strBody = "<ERPINFO><![CDATA[" + strBody.Replace("<br>", "<br />") + "]]></ERPINFO>";
                }
                else if (tp == "UNIERP")
                {
                    using(BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport("EE", 0, "ERPINF_" + formTable, "", "", externalKey1, externalKey2, "", "", "");
                    }
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sbData = new StringBuilder();
                        for (int i = 0; i < svcRt.ResultDataSet.Tables.Count; i++)
                        {
                            DataTable dt = svcRt.ResultDataSet.Tables[i];
                            if (i == 0)
                            {
                                foreach (DataRow row in dt.Rows)
                                {
                                    strBody = "<TGNO>" + row["TEMP_GL_NO"].ToString() + "</TGNO><TGDATE>" + row["TEMP_GL_DT"].ToString() + "</TGDATE>";
                                }
                            }
                            else if (i == 1)
                            {
                                sbData.Append("<subfield><sub1>");
                                foreach (DataRow row in dt.Rows)
                                {
                                    iRow++;
                                    sbData.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ>", iRow.ToString());
                                    foreach (DataColumn col in dt.Columns)
                                    {
                                        sbData.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                    sbData.Append("</row>");
                                }
                                sbData.Append("</sub1></subfield>");
                            }
                            else if (i == 2)
                            {
                                sbData.Append("<mainfield>");
                                foreach (DataRow row in dt.Rows)
                                {
                                    foreach (DataColumn col in dt.Columns)
                                    {
                                        sbData.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                                sbData.Append("</mainfield>");
                            }
                        }
                        //return sbData.ToString();
                        if (sbData.Length > 0)
                        {
                            string strFormPath = HttpContext.Current.Server.MapPath(Framework.Configuration.Config.Read("EAFormHtmlPath") + "/ERPINF_" + formTable + ".xsl");
                            strBody += "<ERPINFO><![CDATA[" + FileHelper.ConvertXmlToHtml("<root>" + sbData.ToString() + "</root>", strFormPath) + "]]></ERPINFO>";
                        }
                    }
                }
                else if (tp == "LCM_MAIN")
                {
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport("RI", Convert.ToInt32(externalKey1), tp, "", "", "", "", "", "", "");
                    }
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sbData = new StringBuilder();
                        DataRow row = svcRt.ResultDataSet.Tables[0].Rows[0];
                        foreach (DataColumn col in svcRt.ResultDataSet.Tables[0].Columns)
                        {
                            sbData.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", ((formTable == "EDUREQUEST" || formTable == "EDUREQUESTIN") && col.ColumnName != "PREID" && col.ColumnName.Substring(0, 4) != "Appl" ? "PRE" : "") + col.ColumnName.ToUpper(), row[col.ColumnName].ToString());
                        }
                        if (formTable == "EDUREQUEST" || formTable == "EDUREQUESTIN") sbData.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", "REQTYPE", "변경");
                        if (sbData.Length > 0) strBody = sbData.ToString();
                    }
                }
                else if (tp == "CE_MAIN") //2020-10-07 개발원가견적표
                {
                    using (BSL.InterfaceBiz.ReportBiz rpBiz = new BSL.InterfaceBiz.ReportBiz())
                    {
                        svcRt = rpBiz.GetReport("", 0, tp, "", "", "", "", "", "", externalKey2);
                    }
                    if (svcRt != null && svcRt.ResultCode == 0)
                    {
                        sbData = new StringBuilder();
                        DataRow row = svcRt.ResultDataSet.Tables[0].Rows[0];
                        foreach (DataColumn col in svcRt.ResultDataSet.Tables[0].Columns)
                        {
                            sbData.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName.ToUpper(), row[col.ColumnName].ToString());
                        }
                        if (sbData.Length > 0) strBody = sbData.ToString();
                    }

                    if (subTblDef != null)
                    {
                        StringBuilder sbSubTables = new StringBuilder("<subtables>");
                        for (int m = 1; m <= subCnt; m++)
                        {
                            XmlNode oSubTable = subTblDef.DocumentElement.SelectSingleNode("subtable" + m.ToString());
                            if (oSubTable != null)
                            {
                                sbSubTables.AppendFormat("<subtable{0}>", m.ToString());
                                if (m == 2 && svcRt.ResultDataSet.Tables.Count == 2)
                                {
                                    int z = 0;
                                    foreach (DataRow row in svcRt.ResultDataSet.Tables[1].Rows)
                                    {
                                        z++;
                                        sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ>", z.ToString());
                                        foreach (DataColumn col in svcRt.ResultDataSet.Tables[1].Columns)
                                        {
                                            if (col.ColumnName != "MessageID" && row[col.ColumnName].ToString() != "")
                                            {
                                                sbSubTables.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                            }
                                        }
                                        sbSubTables.Append("</row>");
                                    }
                                }
                                else
                                {
                                    for (int n = 1; n <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); n++)
                                    {
                                        sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", n.ToString());
                                    }
                                }
                                sbSubTables.AppendFormat("</subtable{0}>", m.ToString());
                            }
                        }
                        sbSubTables.Append("</subtables>");
                        strSubTable = sbSubTables.ToString();
                        sbSubTables = null;
                    }
                }
                strBody = "<maintable>" + strBody + "</maintable>" + strSubTable;
            }
            catch (Exception ex)
            {
                ExceptionManager.ThrowException(ex, System.Reflection.MethodInfo.GetCurrentMethod(), "", "");
            }
            finally
            {
                if (svcRt != null && svcRt.ResultDataSet != null) svcRt.ResultDataSet.Dispose();
            }
            return strBody;
        }

        /// <summary>
        /// 외부와 연계된 본문 정보 구성하기
        /// </summary>
        /// <param name="cn"></param>
        /// <param name="fileInfo"></param>
        /// <param name="sheBody"></param>
        /// <returns></returns>
        private string CallSHEFormData(ref XmlNode fileInfo, ref string sheBody)
        {
            string strMsg = "OK";
            
            return strMsg;
        }

        /// <summary>
        /// 동일 MessageID에 대한 이력 정보 가져오기
        /// </summary>
        /// <param name="procDac"></param>
        /// <param name="dsRecord"></param>
        /// <param name="oID"></param>
        /// <param name="historyData"></param>
        /// <returns></returns>
        private string ComposeFormHistory(ProcessDac procDac, DataSet dsRecord, int oID, ref string historyData)
        {
            DataTable dt = null;
            DataTable dtSI = null;

            StringBuilder sbHistory = new StringBuilder();
            string strHistory1 = "";
            string strHistory2 = "";
            string strActDate = ""; //초까지 비교해서 같으면 같은 이력으로 본다.
            string strPreDate = "";

            string strMsg = "OK";

            try
            {
                //ResponseText("oid->" + oID.ToString()); Response.End();
                if (dsRecord != null)
                {
                    dt = dsRecord.Tables[0];
                    int i = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        strMsg = "[100-" + i.ToString() + "]";
                        strActDate = Convert.ToDateTime(row["ActDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                        //strActDate = "2007-12-21 16:22:24";

                        strMsg = "[200-" + i.ToString() + "]";
                        strHistory2 = "<" + row["FieldName"].ToString() + "><![CDATA["
                                    + row["FieldValue"].ToString() + "]]></" + row["FieldName"].ToString() + ">";

                        if (strPreDate == strActDate)
                        {
                            sbHistory.Append(strHistory2);
                        }
                        else
                        {
                            if (sbHistory.Length > 0) sbHistory.Append("</maintable></history>");

                            if (row["ActorKey"].ToString() != "")
                            {
                                strMsg = "[300-" + i.ToString() + "]";
                                dtSI = procDac.SelectProcessSignInform("C", oID, "", 10, row["ActorKey"].ToString());
                                //dtSI = processDB.SelectProcessSignInform(cn, "D", oID, strActDate, 10, "");
                                if ((dtSI != null) && (dtSI.Rows.Count > 0))
                                {
                                    strHistory1 = "<signline><lines>"
                                                + dtSI.Rows[0]["SignInfo"].ToString()
                                                + "</lines></signline>";
                                    dtSI.Dispose();
                                    dtSI = null;

                                    //ResponseText(strMsg + " : " + row["ActorKey"].ToString());
                                }
                            }
                            sbHistory.AppendFormat("<history date=\"{0}\" viewkey=\"{1}\">", strActDate, row["ActorKey"].ToString());
                            sbHistory.Append(strHistory1);
                            //sbHistory.AppendFormat("<maintable date=\"{0}\" actorkey=\"{1}\">{2}", strActDate, row["ActorKey"].ToString(), strHistory2);
                            sbHistory.AppendFormat("<maintable>{0}", strHistory2);
                        }
                        strHistory1 = "";
                        strHistory2 = "";
                        strPreDate = strActDate;
                        i++;
                    }
                    //같은 시각으로 루프를 나오면 마지막은 닫히지 않는다.
                    if (strPreDate == strActDate)
                    {
                        if (sbHistory.Length > 0) sbHistory.Append("</maintable></history>");
                    }
                }
                strMsg = "OK";
            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "ComposeFormHistory");
            }
            finally
            {
                if (dt != null)
                {
                    dt.Dispose();
                    dt = null;
                }
                if (dtSI != null)
                {
                    dtSI.Dispose();
                    dtSI = null;
                }
            }
            historyData = sbHistory.ToString();
            return strMsg;
        }

        /// <summary>
        /// 특정 외부키에 해당되는 양식 정보를 구성한다.
        /// </summary>
        /// <param name="eaDac"></param>
        /// <param name="procDac"></param>
        /// <param name="rowList"></param>
        /// <param name="msgID"></param>
        /// <param name="oID"></param>
        /// <param name="anotherInfo"></param>
        /// <returns></returns>
        private string ComposeFormHistoryByExternalKey(EApprovalDac eaDac, ProcessDac procDac, ArrayList rowList, int msgID, int oID, ref string anotherInfo)
        {
            DataSet dsForm = null;
            DataSet dsRecord = null;
            WorkItemList wiList = null;

            string strAnother = "";
            string strFormInfo = "";
            string strProcessInfo = "";
            string strHistory = "";
            string strActDate = "";

            string strMsg = "";
            int iLoop = 0;

            try
            {
                foreach (object[] row in rowList)
                {
                    if (msgID != Convert.ToInt32(row[0]))
                    {
                        strActDate = Convert.ToDateTime(row[2]).ToString("yyyy-MM-dd HH:mm:ss");
                        strMsg = "H-100[" + iLoop.ToString() + "]";
                        dsForm = eaDac.SelectFormData(_formDB, Convert.ToInt32(row[0]), row[3].ToString(), Convert.ToInt32(row[4]), Convert.ToInt32(row[5]));

                        strMsg = "H-200[" + iLoop.ToString() + "]";
                        dsRecord = eaDac.SelectHistoryData(_formDB, Convert.ToInt32(row[0]), row[3].ToString(), Convert.ToInt32(row[4]));

                        strMsg = "H-300[" + iLoop.ToString() + "]";
                        wiList = procDac.SelectWorkItems(Convert.ToInt32(row[1]));

                        strMsg = "H-400[" + iLoop.ToString() + "]";
                        strFormInfo = "<forminfo>" + ComposeFormData(dsForm, (XmlDocument)null, 0) + "</forminfo>";

                        strMsg = "H-500[" + iLoop.ToString() + "]";
                        strProcessInfo = "<processinfo><signline><lines>"
                                        + WorkListHelper.ConvertWorkItemListToXmlLine(wiList, "view")
                                        + "</lines></signline></processinfo>";

                        strMsg = "H-600[" + iLoop.ToString() + "]";
                        strMsg = ComposeFormHistory(procDac, dsRecord, Convert.ToInt32(row[1]), ref strHistory);
                        strHistory = "<historyinfo>" + strHistory + "</historyinfo>";

                        strMsg = "H-700[" + iLoop.ToString() + "]";
                        strAnother += String.Format("<anothermsg date=\"{0}\" oid=\"{1}\" msgid=\"{2}\">{3}{4}{5}</anothermsg>"
                                        , strActDate, row[1].ToString(), row[0].ToString(), strFormInfo, strProcessInfo, strHistory);

                        //ResponseText(strProcessInfo); return "";
                    }
                }
                strMsg = "OK";
            }
            catch (Exception ex)
            {
                strMsg += Environment.NewLine + ex.Message;
                ExceptionManager.Publish(ex, ExceptionManager.ErrorLevel.Error, "ComposeFormHistoryByExternalKey");
            }
            finally
            {
                if (dsForm != null)
                {
                    dsForm.Dispose();
                    dsForm = null;
                }
                if (dsRecord != null)
                {
                    dsRecord.Dispose();
                    dsRecord = null;
                }
            }
            anotherInfo = strAnother;
            return strMsg;
        }

        /// <summary>
        /// 저장된 양식 데이타 구성(2011-08-09 보완 -> 2011-10-13 추가 보완)
        /// </summary>
        /// <param name="formData"></param>
        /// <returns></returns>
        private string ComposeFormData(DataSet formData, XmlDocument subTblDef, int subCnt)
        {
            DataTable dt = null;
            StringBuilder sbTable = new StringBuilder();
            StringBuilder sbSubTables = new StringBuilder();
            XmlNode oSubTable = null;
            int x = 0;

            if (formData != null && formData.Tables.Count > 0)
            {
                for (x = 0; x < formData.Tables.Count; x++)
                {
                    dt = formData.Tables[x];
                    if (x == 0)
                    {
                        sbTable.Append("<maintable>");
                        foreach (DataRow row in dt.Rows)
                        {
                            foreach (DataColumn col in dt.Columns)
                            {
                                if (col.ColumnName != "MessageID" && row[col.ColumnName].ToString() != "")
                                {
                                    if (col.ColumnName == "WEBEDITOR")
                                    {
                                        sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, Framework.Web.HtmlHandler.BodyInnerHtml(row[col.ColumnName].ToString()));
                                    }
                                    else
                                    {
                                        sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                            }
                        }
                        sbTable.Append("</maintable>");
                    }
                    else
                    {
                        //if (x == 1) sbSubTables.Append("<subtables>");
                        sbSubTables.AppendFormat("<subtable{0}>", x.ToString());
                        foreach (DataRow row in dt.Rows)
                        {
                            sbSubTables.Append("<row>");
                            foreach (DataColumn col in dt.Columns)
                            {
                                if ((col.ColumnName != "MessageID") && (row[col.ColumnName].ToString() != ""))
                                {
                                    sbSubTables.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName
                                                            , row[col.ColumnName].ToString());
                                }
                            }
                            sbSubTables.Append("</row>");
                        }

                        if (subTblDef != null)
                        {
                            oSubTable = subTblDef.DocumentElement.SelectSingleNode("subtable" + x.ToString());
                            if (oSubTable != null)
                            {
                                for (int y = dt.Rows.Count + 1; y <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); y++)
                                {
                                    sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", y.ToString());
                                }
                            }
                            oSubTable = null;
                        }
                        sbSubTables.AppendFormat("</subtable{0}>", x.ToString());
                        //if (x == formData.Tables.Count - 1) sbSubTables.Append("</subtables>");
                    }
                }

                //가져온 데이타 하위테이블수보다 현 양식 하위테이블 수가 많은 경우..2011-10-13 추가
                if (subCnt >= x)
                {
                    for (int m = x; m <= subCnt; m++)
                    {
                        oSubTable = subTblDef.DocumentElement.SelectSingleNode("subtable" + m.ToString());
                        if (oSubTable != null)
                        {
                            sbSubTables.AppendFormat("<subtable{0}>", m.ToString());
                            for (int n = 1; n <= Convert.ToInt32(oSubTable.Attributes["cnt"].Value); n++)
                            {
                                sbSubTables.AppendFormat("<row><ROWSEQ>{0}</ROWSEQ></row>", n.ToString());
                            }
                            sbSubTables.AppendFormat("</subtable{0}>", m.ToString());
                        }
                    }
                }
            }
            return sbTable.ToString() + "<subtables>" + sbSubTables.ToString() + "</subtables>";
        }

        /// <summary>
        /// 결재 이외의 양식 본문 구성(2011-08-19)
        /// </summary>
        /// <param name="formData"></param>
        /// <returns></returns>
        private string ComposeFormData(DataSet formData)
        {
            DataTable dt = null;
            StringBuilder sbTable = new StringBuilder();
            StringBuilder sbSubTables = new StringBuilder();
            XmlNode oSubTable = null;

            if (formData != null && formData.Tables.Count > 0)
            {
                for (int x = 0; x < formData.Tables.Count; x++)
                {
                    dt = formData.Tables[x];
                    if (x == 0)
                    {
                        sbTable.Append("<maintable>");
                        foreach (DataRow row in dt.Rows)
                        {
                            foreach (DataColumn col in dt.Columns)
                            {
                                if (col.ColumnName != "fiid" && row[col.ColumnName].ToString() != "")
                                {
                                    if (col.ColumnName == "WEBEDITOR")
                                    {
                                        sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, Framework.Web.HtmlHandler.BodyInnerHtml(row[col.ColumnName].ToString()));
                                    }
                                    else
                                    {
                                        sbTable.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName, row[col.ColumnName].ToString());
                                    }
                                }
                            }
                        }
                        sbTable.Append("</maintable>");
                    }
                    else
                    {
                        if (x == 1) sbSubTables.Append("<subtables>");
                        sbSubTables.AppendFormat("<subtable{0}>", x.ToString());
                        foreach (DataRow row in dt.Rows)
                        {
                            sbSubTables.Append("<row>");
                            foreach (DataColumn col in dt.Columns)
                            {
                                if ((col.ColumnName != "MessageID") && (row[col.ColumnName].ToString() != ""))
                                {
                                    sbSubTables.AppendFormat("<{0}><![CDATA[{1}]]></{0}>", col.ColumnName
                                                            , row[col.ColumnName].ToString());
                                }
                            }
                            sbSubTables.Append("</row>");
                        }
                        sbSubTables.AppendFormat("</subtable{0}>", x.ToString());
                        if (x == formData.Tables.Count - 1) sbSubTables.Append("</subtables>");
                    }
                }
            }
            return sbTable.ToString() + sbSubTables.ToString();
        }
        #endregion
    }
}