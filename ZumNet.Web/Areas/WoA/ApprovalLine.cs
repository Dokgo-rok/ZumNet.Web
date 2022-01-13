using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using ZumNet.Framework.Entities.Flow;
using ZumNet.Framework.Util;

namespace ZumNet.Web.Areas.WoA
{
	/// <summary>
	/// 결재선 
	/// </summary>
	public class ApprovalLine
	{
		private WorkItemList workItemList;
		public string Command = "";
		public string SignLineXml = "";

		public ApprovalLine()
		{

		}

		public ApprovalLine(DataTable dt)
		{
			int rowCount = dt?.Rows?.Count ?? 0;

			if (rowCount == 0)
			{
				return;
			}

			this.workItemList = new WorkItemList();

			foreach (DataRow dr in dt.Rows)
			{
				WorkItem wi = new WorkItem();

				wi.WorkItemID = dr["WorkItemID"].ToString();
				wi.OID = Convert.ToInt32(dr["OID"]);
				wi.ParentWorkItemID = dr["ParentWorkItemID"].ToString();
				wi.Priority = Convert.ToInt16(dr["Priority"]);
				wi.Step = Convert.ToInt16(dr["Step"]);
				wi.SubStep = Convert.ToInt16(dr["SubStep"]);
				wi.Seq = Convert.ToInt16(dr["Seq"]);
				wi.State = Convert.ToInt16(dr["State"]);
				wi.SignStatus = Convert.ToInt16(dr["SignStatus"]);
				wi.SignKind = Convert.ToInt16(dr["SignKind"]);
				wi.ViewState = Convert.ToInt16(dr["ViewState"]);
				wi.Flag = dr["Flag"].ToString();
				wi.Designator = dr["Designator"].ToString();
				wi.ActivityID = dr["ActivityID"].ToString();
				wi.BizRole = dr["BizRole"].ToString();
				wi.ActRole = dr["ActRole"].ToString();
				wi.ParticipantID = dr["ParticipantID"].ToString();
				wi.PartType = dr["PartType"].ToString();
				wi.Limited = dr["Limited"].ToString();
				wi.CreateDate = Convert.ToDateTime(dr["CreateDate"]).ToString("yyyy-MM-dd HH:mm:ss");
				wi.ReceivedDate = Convert.ToDateTime(dr["ReceivedDate"]).ToString("yyyy-MM-dd HH:mm:ss");
				wi.ViewDate = Convert.ToDateTime(dr["ViewDate"]).ToString("yyyy-MM-dd HH:mm:ss");
				wi.CompletedDate = Convert.ToDateTime(dr["CompletedDate"]).ToString("yyyy-MM-dd HH:mm:ss");
				wi.CompetencyCode = Convert.ToInt32(dr["CompetencyCode"]);
				wi.Point = dr["Point"].ToString();
				wi.Signature = dr["Signature"].ToString();
				wi.Comment = dr["Comment"].ToString();
				wi.ParticipantName = dr["ParticipantName"].ToString();
				wi.ParticipantDeptCode = dr["ParticipantDeptCode"].ToString();
				wi.ParticipantInfo1 = dr["ParticipantInfo1"].ToString();
				wi.ParticipantInfo2 = dr["ParticipantInfo2"].ToString();
				wi.ParticipantInfo3 = dr["ParticipantInfo3"].ToString();
				wi.ParticipantInfo4 = dr["ParticipantInfo4"].ToString();
				wi.ParticipantInfo5 = dr["ParticipantInfo5"].ToString();
				wi.ParticipantInfo6 = dr["ParticipantInfo6"].ToString();
				wi.Reserved1 = dr["Reserved1"].ToString();
				wi.Reserved2 = dr["Reserved2"].ToString();

				this.workItemList.Add(wi);
			}
		}

		private void CreateSignLine()
		{
			StringBuilder sbLine = new StringBuilder(1024);

			this.SignLineXml = "<signline><lines mode=\"" + "read"
									+ "\" bizrole=\"" + ""
									+ "\" actrole=\"" + ""
									+ "\" curwid=\"" + ""
									+ "\" parentwid=\"" + "" + "\">";

			for (int i = this.workItemList.Items.Count - 1; i >= 0; i--)
			{
				bool isMakeLine = false;
				WorkItem wi = this.workItemList.Items[i];

				if (wi.Step == 0)
				{
					if (String.Compare(this.Command, "full", true) == 0)
					{
						isMakeLine = true;
					}
				}
				else
				{
					isMakeLine = true;
				}

				if (isMakeLine)
				{
					string strInterval = "";

					if (!string.IsNullOrWhiteSpace(wi.ReceivedDate))
					{
						strInterval = (String.IsNullOrWhiteSpace(wi.CompletedDate)) ? CalcDateDiff(wi.ReceivedDate, DateTime.Now.ToString("yyyy-MM-dd HH:mm:dd")) : CalcDateDiff(wi.ReceivedDate, wi.CompletedDate);
					}

					sbLine.AppendFormat("<line mode=\"{0}\" wid=\"{1}\" parent=\"{2}\" ", wi.Mode, wi.WorkItemID, wi.ParentWorkItemID);
					sbLine.AppendFormat("step=\"{0}\" substep=\"{1}\" seq=\"{2}\" ", wi.Step.ToString(), wi.SubStep.ToString(), wi.Seq.ToString());
					sbLine.AppendFormat("state=\"{0}\" signstatus=\"{1}\" signkind=\"{2}\" viewstate=\"{3}\" ", wi.State, wi.SignStatus, wi.SignKind, wi.ViewState);
					sbLine.AppendFormat("activityid=\"{0}\" bizrole=\"{1}\" actrole=\"{2}\" parttype=\"{3}\" ", wi.ActivityID, wi.BizRole, wi.ActRole, wi.PartType);
					sbLine.AppendFormat("partid=\"{0}\" deptcode=\"{1}\" competency=\"{2}\" point=\"{3}\" ", wi.ParticipantID, wi.ParticipantDeptCode, wi.CompetencyCode, wi.Point);
					sbLine.AppendFormat("received=\"{0}\" view=\"{1}\" completed=\"{2}\"", CheckDateTiem(wi.ReceivedDate), CheckDateTiem(wi.ViewDate), CheckDateTiem(wi.CompletedDate));
					sbLine.AppendFormat(" interval=\"{0}\">", strInterval);
					sbLine.AppendFormat("<partname><![CDATA[{0}]]></partname>", wi.ParticipantName);
					sbLine.AppendFormat("<part1><![CDATA[{0}]]></part1>", wi.ParticipantInfo1); //부서명
					sbLine.AppendFormat("<part2><![CDATA[{0}]]></part2>", wi.ParticipantInfo2); //계정
					sbLine.AppendFormat("<part3><![CDATA[{0}]]></part3>", wi.ParticipantInfo3); //사번
					sbLine.AppendFormat("<part4><![CDATA[{0}]]></part4>", wi.ParticipantInfo4); //메일계정
					sbLine.AppendFormat("<part5><![CDATA[{0}]]></part5>", wi.ParticipantInfo5); //직위
					sbLine.AppendFormat("<part6><![CDATA[{0}]]></part6>", wi.ParticipantInfo6); //직급
					sbLine.AppendFormat("<comment><![CDATA[{0}]]></comment>", wi.Comment);
					sbLine.AppendFormat("<sign><![CDATA[{0}]]></sign>", wi.Signature);

					if (!string.IsNullOrWhiteSpace(wi.Reserved1))
					{
						sbLine.AppendFormat("<reserved1><![CDATA[{0}]]></reserved1>", wi.Reserved1);
					}

					if (!string.IsNullOrWhiteSpace(wi.Reserved2))
					{
						sbLine.AppendFormat("<reserved1><![CDATA[{0}]]></reserved1>", wi.Reserved2);
					}

					sbLine.Append("</line>");
				}
			}

			this.SignLineXml += sbLine.ToString();
			this.SignLineXml += "</lines></signline>";
		}

		/// <summary>
		/// 결재선 정보 HTML 생성
		/// </summary>
		/// <param name="dtBizRole"></param>
		/// <param name="dtActRole"></param>
		/// <returns></returns>
		public string GetApprovalLineHtml(DataTable dtBizRole, DataTable dtActRole)
		{
			// Line 생성
			CreateSignLine();

			// XML 파싱
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(this.SignLineXml);
			XmlNodeList nodes = xmlDoc.SelectNodes("//line[@parent='' and @partid!='' and @step!='0' and @bizrole!='reference']");

			StringBuilder sbHtml = new StringBuilder(1024);

			sbHtml.Append($"<div class=\"table-responsive\">");
			sbHtml.Append($"<table class=\"table table-bordered\" style=\"border: 1px solid #eee;\">");
			sbHtml.Append($"	<thead>");
			sbHtml.Append($"		<tr>");
			sbHtml.Append($"			<th style=\"width:5%\">순번</th>");
			sbHtml.Append($"			<th style=\"width:10%\">분류</th>");
			sbHtml.Append($"			<th style=\"width:22%\">결재자</th>");
			sbHtml.Append($"			<th style=\"width:9%\">상태</th>");
			sbHtml.Append($"			<th style=\"width:8%\">종류</th>");
			sbHtml.Append($"			<th style=\"width:8%\">역할</th>");
			sbHtml.Append($"			<th style=\"width:14%\">결재시각</th>");
			sbHtml.Append($"			<th style=\"width:14%\">받은시각</th>");
			sbHtml.Append($"			<th style=\"width:10%\">소요시간</th>");
			sbHtml.Append($"		</tr>"); 
			sbHtml.Append($"	</thead>");
			sbHtml.Append($"	<tbody>");

			foreach (XmlNode node in nodes)
			{
				if (String.Compare(node.Attributes["state"].Value, "2", true) == 0 && String.Compare(node.Attributes["viewstate"].Value, "3", true) == 0)
				{
					//sbHTML.Append("<tr class=\"si-cur\">");
					sbHtml.Append($"<tr>");
				}
				else
				{
					sbHtml.Append($"<tr>");
				}

				string seqText = node.Attributes["step"].Value + (String.Compare(node.Attributes["substep"].Value, "0", true) == 0 ? "" : "." + node.Attributes["substep"].Value);

				sbHtml.Append($"		<td>{seqText}</td>");

				if (isGroup(node.Attributes["parttype"].Value))
				{
					sbHtml.Append($"	<td>{FindRoleValue(dtBizRole, node.Attributes["bizrole"].Value)}</td>");
					sbHtml.Append($"	<td>{isEmpty(node.SelectSingleNode("partname").InnerText)}</td>");
				}
				else
				{
					if (String.Compare(node.Attributes["bizrole"].Value, "normal", true) == 0 || String.Compare(node.Attributes["bizrole"].Value, "receive", true) == 0)
					{
						sbHtml.Append($"<td>{FindRoleValue(dtActRole, node.Attributes["actrole"].Value)}</td>");
					}
					else if (String.Compare(node.Attributes["bizrole"].Value, "gwichaek", true) == 0)
					{
						sbHtml.Append($"<td>{FindRoleValue(dtActRole, node.Attributes["actrole"].Value)}</td>");
					}
					else if (String.Compare(node.Attributes["bizrole"].Value, "application", true) == 0 && String.Compare(FindRoleValue(dtActRole, node.Attributes["actrole"].Value), "_reviewer", true) == 0)
					{
						sbHtml.Append($"<td>{FindRoleValue(dtActRole, node.Attributes["actrole"].Value)}</td>");
					}
					else
					{
						sbHtml.Append($"<td>{FindRoleValue(dtBizRole, node.Attributes["bizrole"].Value)}</td>");
					}

					sbHtml.Append($"	<td>{isEmpty(node.SelectSingleNode("part1").InnerText)}.{isEmpty(node.SelectSingleNode("partname").InnerText)}</td>");
				}

				sbHtml.Append($"		<td>{ProcessStateChart.ParsingWorkItemStateToDisplayText(StringHelper.SafeInt(node.Attributes["state"].Value))}</td>");
				sbHtml.Append($"		<td>{ProcessStateChart.ParsingSignStatusToDisplayText(StringHelper.SafeInt(node.Attributes["signstatus"].Value))}</td>");
				sbHtml.Append($"		<td>일반</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["completed"].Value.ToString())}</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["received"].Value.ToString())}</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["interval"].Value.ToString())}</td>");
				sbHtml.Append($"	</tr>");

				string comment = (String.Compare(node.Attributes["state"].Value, "2", true) == 0 || String.Compare(node.Attributes["state"].Value, "3", true) == 0) ? "" : node.SelectSingleNode("comment").InnerText;

				if (!String.IsNullOrWhiteSpace(comment.Replace(" ", "")))
				{
					sbHtml.Append($"<tr>");
					sbHtml.Append($"	<td colspan=\"2\">&nbsp;</td>");
					sbHtml.Append($"	<td colspan=\"7\">{encodeHtml(comment)}</td>");
					sbHtml.Append($"</tr>");
				}

				XmlNodeList childNodeList = xmlDoc.SelectNodes("//line[@parent='" + node.Attributes["wid"].Value + "' and @partid!='' and @step!='0' and @bizrole!='reference']");

				int childNodeCount = childNodeList?.Count ?? 0;

				if (childNodeCount > 0)
				{
					sbHtml.Append($"<tr>");
					sbHtml.Append($"	<td colspan=\"9\">");
					sbHtml.Append($"		<table class=\"table table-bordered\" style=\"border: 1px solid #eee;\">");
					sbHtml.Append($"			<colgroup><col style=\"width:4%\" /><col style=\"width:10%\" /><col style=\"width:22%\" /><col style=\"width:9%\" /><col style=\"width:8%\" /><col style=\"width:8%\" /><col style=\"width:14%\" /><col style=\"width:14%\" /><col style=\"width:10%\" /></colgroup>");

					foreach (XmlNode cNode in childNodeList)
					{
						sbHtml.Append($"		<tr>");

						string subSeqText = cNode.Attributes["step"].Value + (String.Compare(cNode.Attributes["substep"].Value, "0", true) == 0 ? "" : "." + cNode.Attributes["substep"].Value);

						sbHtml.Append($"			<td>{subSeqText}</td>");
						sbHtml.Append($"			<td>{FindRoleValue(dtActRole, cNode.Attributes["actrole"].Value)}</td>");
						sbHtml.Append($"			<td>{isEmpty(cNode.SelectSingleNode("part1").InnerText)}.{isEmpty(cNode.SelectSingleNode("partname").InnerText)}</td>");
						sbHtml.Append($"			<td>{ProcessStateChart.ParsingWorkItemStateToDisplayText(StringHelper.SafeInt(cNode.Attributes["state"].Value))}</td>");
						sbHtml.Append($"			<td>{ProcessStateChart.ParsingSignStatusToDisplayText(StringHelper.SafeInt(cNode.Attributes["signstatus"].Value))}</td>");
						sbHtml.Append($"			<td>{FindRoleValue(dtBizRole, cNode.Attributes["bizrole"].Value)}</td>");
						sbHtml.Append($"			<td>{isEmpty(cNode.Attributes["completed"].Value.ToString())}</td>");
						sbHtml.Append($"			<td>{isEmpty(cNode.Attributes["received"].Value.ToString())}</td>");
						sbHtml.Append($"			<td>{isEmpty(cNode.Attributes["interval"].Value.ToString())}</td>");
						sbHtml.Append($"		</tr>");

						string subComment = (String.Compare(cNode.Attributes["state"].Value, "2", true) == 0 || String.Compare(cNode.Attributes["state"].Value, "3", true) == 0) ? "" : cNode.SelectSingleNode("comment").InnerText;

						if (!String.IsNullOrWhiteSpace(subComment.Replace(" ", "")))
						{
							sbHtml.Append($"	<tr>");
							sbHtml.Append($"		<td colspan=\"2\">&nbsp;</td>");
							sbHtml.Append($"		<td colspan=\"7\">{encodeHtml(subComment)}</td>");
							sbHtml.Append($"	</tr>");
						}
					}

					sbHtml.Append($"		</table>");
					sbHtml.Append($"	</td>");
					sbHtml.Append($"</tr>");
				}
			}

			sbHtml.Append($"	</tbody>");
			sbHtml.Append($"</table>");

			//참조목록
			XmlNodeList refNodeList = xmlDoc.SelectNodes("//line[@partid!='' and @step!='0' and @bizrole='reference']");

			int refNodeCount = refNodeList?.Count ?? 0;

			if (refNodeCount > 0)
			{
				sbHtml.Append($"<table class=\"table table-bordered mt-10\" style=\"border: 1px solid #eee;\">");
				sbHtml.Append($"	<tr>");
				sbHtml.Append($"		<td style=\"width:10%\"><div class=\"form-control-plaintext\">참조 목록</div></td>");
				sbHtml.Append($"		<td style=\"width:90%\">");

				string refText = "";

				foreach (XmlNode rNode in refNodeList)
				{
					if (isGroup(rNode.Attributes["parttype"].Value))
					{
						refText += isEmpty(rNode.SelectSingleNode("partname").InnerText) + ",";
					}
					else
					{
						refText += $"{isEmpty(rNode.SelectSingleNode("part1").InnerText)}.{isEmpty(rNode.SelectSingleNode("partname").InnerText)},";
					}
				}

				sbHtml.Append($"			<div class=\"form-control-plaintext\">{refText.TrimEnd(',').Replace(",", ",&nbsp;&nbsp;")}</div>");
				sbHtml.Append($"		</td>");
				sbHtml.Append($"	</tr>");
				sbHtml.Append($"</table>");
			}

			sbHtml.Append($"</div>");

			return sbHtml.ToString();
		}

		/// <summary>
		/// WorkItem 정보 HTML 생성
		/// </summary>
		/// <param name="dtBizRole"></param>
		/// <param name="dtActRole"></param>
		/// <returns></returns>
		public string GetWorkItemHtml(DataTable dtBizRole, DataTable dtActRole)
		{
			// Line 생성
			CreateSignLine();

			// XML 파싱
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(this.SignLineXml);
			XmlNodeList nodes = xmlDoc.SelectNodes("//line[@parent='' and @partid!='' and @step!='0' and @bizrole!='reference']");

			StringBuilder sbHtml = new StringBuilder(1024);

			sbHtml.Append($"<div class=\"table-responsive\">");
			sbHtml.Append($"<table class=\"table table-bordered\" style=\"border: 1px solid #eee;\">");
			sbHtml.Append($"	<thead>");
			sbHtml.Append($"		<tr>");
			sbHtml.Append($"			<th style=\"width:2%\">&nbsp;</th>");
			sbHtml.Append($"			<th style=\"width:5%\">순번</th>");
			sbHtml.Append($"			<th style=\"width:10%\">분류</th>");
			sbHtml.Append($"			<th style=\"width:10%\">역할</th>");
			sbHtml.Append($"			<th style=\"width:16%\">참여자</th>");
			sbHtml.Append($"			<th style=\"width:8%\">상태</th>");
			sbHtml.Append($"			<th style=\"width:8%\">종류</th>");
			sbHtml.Append($"			<th style=\"width:8%\">구분</th>");
			sbHtml.Append($"			<th style=\"width:11%\">받은시각</th>");
			sbHtml.Append($"			<th style=\"width:11%\">조회시각</th>");
			sbHtml.Append($"			<th style=\"width:11%\">결재시각</th>");
			sbHtml.Append($"		</tr>");
			sbHtml.Append($"	</thead>");
			sbHtml.Append($"	<tbody>");

			foreach (XmlNode node in nodes)
			{
				if (String.Compare(node.Attributes["state"].Value, "2", true) == 0 && String.Compare(node.Attributes["viewstate"].Value, "3", true) == 0)
				{
					//sbHTML.Append("<tr class=\"si-cur\">");
					sbHtml.Append($"<tr>");
				}
				else
				{
					sbHtml.Append($"<tr>");
				}

				sbHtml.Append($"		<td><label class=\"custom-control custom-checkbox\"><input type=\"checkbox\" class=\"custom-control-input\"><span class=\"custom-control-label\"></span></label></td>");
				sbHtml.Append($"		<td>{node.Attributes["step"].Value}.{node.Attributes["substep"].Value}.{node.Attributes["seq"].Value}</td>");
				sbHtml.Append($"		<td>{FindRoleValue(dtBizRole, node.Attributes["bizrole"].Value)}</td>");
				sbHtml.Append($"		<td>{FindRoleValue(dtActRole, node.Attributes["actrole"].Value)}</td>");

				if (isGroup(node.Attributes["parttype"].Value))
				{
					sbHtml.Append($"	<td>{isEmpty(node.SelectSingleNode("partname").InnerText)}</td>");
				}
				else
				{
					sbHtml.Append($"	<td>{isEmpty(node.SelectSingleNode("part1").InnerText)}.{isEmpty(node.SelectSingleNode("partname").InnerText)}</td>");
				}

				sbHtml.Append($"		<td>{ProcessStateChart.ParsingWorkItemStateToDisplayText(StringHelper.SafeInt(node.Attributes["state"].Value))}</td>");
				sbHtml.Append($"		<td>{ProcessStateChart.ParsingSignStatusToDisplayText(StringHelper.SafeInt(node.Attributes["signstatus"].Value))}</td>");
				sbHtml.Append($"		<td>{node.Attributes["signkind"].Value}</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["received"].Value.ToString())}</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["view"].Value.ToString())}</td>");
				sbHtml.Append($"		<td>{isEmpty(node.Attributes["completed"].Value.ToString())}</td>");
				sbHtml.Append($"	</tr>");

				string comment = (String.Compare(node.Attributes["state"].Value, "2", true) == 0 || String.Compare(node.Attributes["state"].Value, "3", true) == 0) ? "" : node.SelectSingleNode("comment").InnerText;

				if (!String.IsNullOrWhiteSpace(comment.Replace(" ", "")))
				{
					sbHtml.Append($"<tr>");
					sbHtml.Append($"	<td colspan=\"2\">&nbsp;</td>");
					sbHtml.Append($"	<td colspan=\"9\">{encodeHtml(comment)}</td>");
					sbHtml.Append($"</tr>");
				}

				XmlNodeList childNodeList = xmlDoc.SelectNodes("//line[@parent='" + node.Attributes["wid"].Value + "' and @partid!='' and @bizrole!='reference']");

				int childNodeCount = childNodeList?.Count ?? 0;

				if (childNodeCount > 0)
				{
					sbHtml.Append($"<tr>");
					sbHtml.Append($"	<td colspan=\"11\">");
					sbHtml.Append($"		<table class=\"table table-bordered\" style=\"border: 1px solid #eee;\">");
					sbHtml.Append($"			<colgroup><col style=\"width:2%\" /><col style=\"width:4%\" /><col style=\"width:10%\" /><col style=\"width:10%\" /><col style=\"width:16%\" /><col style=\"width:8%\" /><col style=\"width:8%\" /><col style=\"width:8%\" /><col style=\"width:11%\" /><col style=\"width:11%\" /><col style=\"width:11%\" /></colgroup>");

					foreach (XmlNode cNode in childNodeList)
					{
						sbHtml.Append($"		<tr>");

						string subSeqText = cNode.Attributes["step"].Value + (String.Compare(cNode.Attributes["substep"].Value, "0", true) == 0 ? "" : "." + cNode.Attributes["substep"].Value);

						sbHtml.Append($"			<td><label class=\"custom-control custom-checkbox\"><input type=\"checkbox\" class=\"custom-control-input\"><span class=\"custom-control-label\"></span></label></td>");
						sbHtml.Append($"			<td>{cNode.Attributes["step"].Value}.{cNode.Attributes["substep"].Value}.{cNode.Attributes["seq"].Value}</td>");
						sbHtml.Append($"			<td>{FindRoleValue(dtBizRole, cNode.Attributes["bizrole"].Value)}</td>");
						sbHtml.Append($"			<td>{FindRoleValue(dtActRole, cNode.Attributes["actrole"].Value)}</td>");

						if (isGroup(cNode.Attributes["parttype"].Value))
						{
							sbHtml.Append($"	<td>{isEmpty(cNode.SelectSingleNode("partname").InnerText)}</td>");
						}
						else
						{
							sbHtml.Append($"	<td>{isEmpty(cNode.SelectSingleNode("part1").InnerText)}.{isEmpty(cNode.SelectSingleNode("partname").InnerText)}</td>");
						}

						sbHtml.Append($"		<td>{ProcessStateChart.ParsingWorkItemStateToDisplayText(StringHelper.SafeInt(cNode.Attributes["state"].Value))}</td>");
						sbHtml.Append($"		<td>{ProcessStateChart.ParsingSignStatusToDisplayText(StringHelper.SafeInt(cNode.Attributes["signstatus"].Value))}</td>");
						sbHtml.Append($"		<td>{cNode.Attributes["signkind"].Value}</td>");
						sbHtml.Append($"		<td>{isEmpty(cNode.Attributes["received"].Value.ToString())}</td>");
						sbHtml.Append($"		<td>{isEmpty(cNode.Attributes["view"].Value.ToString())}</td>");
						sbHtml.Append($"		<td>{isEmpty(cNode.Attributes["completed"].Value.ToString())}</td>");
						sbHtml.Append($"	</tr>");

						string subComment = (String.Compare(cNode.Attributes["state"].Value, "2", true) == 0 || String.Compare(cNode.Attributes["state"].Value, "3", true) == 0) ? "" : cNode.SelectSingleNode("comment").InnerText;

						if (!String.IsNullOrWhiteSpace(subComment.Replace(" ", "")))
						{
							sbHtml.Append($"	<tr>");
							sbHtml.Append($"		<td colspan=\"2\">&nbsp;</td>");
							sbHtml.Append($"		<td colspan=\"9\">{encodeHtml(subComment)}</td>");
							sbHtml.Append($"	</tr>");
						}
					}

					sbHtml.Append($"		</table>");
					sbHtml.Append($"	</td>");
					sbHtml.Append($"</tr>");
				}
			}

			sbHtml.Append($"	</tbody>");
			sbHtml.Append($"</table>");

			//참조목록
			XmlNodeList refNodeList = xmlDoc.SelectNodes("//line[@partid!='' and @step!='0' and @bizrole='reference']");

			int refNodeCount = refNodeList?.Count ?? 0;

			if (refNodeCount > 0)
			{
				sbHtml.Append($"<table class=\"table table-bordered mt-10\" style=\"border: 1px solid #eee;\">");
				sbHtml.Append($"	<tr>");
				sbHtml.Append($"		<td style=\"width:10%\"><div class=\"form-control-plaintext\">참조 목록</div></td>");
				sbHtml.Append($"		<td style=\"width:90%\">");

				string refText = "";

				foreach (XmlNode rNode in refNodeList)
				{
					if (isGroup(rNode.Attributes["parttype"].Value))
					{
						refText += isEmpty(rNode.SelectSingleNode("partname").InnerText) + ",";
					}
					else
					{
						refText += $"{isEmpty(rNode.SelectSingleNode("part1").InnerText)}.{isEmpty(rNode.SelectSingleNode("partname").InnerText)},";
					}
				}

				sbHtml.Append($"			<div class=\"form-control-plaintext\">{refText.TrimEnd(',').Replace(",", ",&nbsp;&nbsp;")}</div>");
				sbHtml.Append($"		</td>");
				sbHtml.Append($"	</tr>");
				sbHtml.Append($"</table>");
			}

			sbHtml.Append($"</div>");

			return sbHtml.ToString();
		}

		private string CalcDateDiff(string sD, string eD)
		{
			TimeSpan ts = DateTime.Parse(eD) - DateTime.Parse(sD);
			if (ts.Days > 0) return ts.Days.ToString() + "d" + ts.Hours.ToString() + "h" + ts.Minutes.ToString() + "m";
			else if (ts.Hours > 0) return ts.Hours.ToString() + "h" + ts.Minutes.ToString() + "m";
			else return ts.Minutes.ToString() + "m";
		}

		private string CheckDateTiem(string date)
		{
			string strReturn = "";

			if (date != "")
			{
				try
				{
					DateTime d = Convert.ToDateTime(date);
					if (d != null) if (DateTime.Compare(d, Convert.ToDateTime("2999-01-01")) < 0) strReturn = d.ToString("yy-MM-dd HH:mm");
				}
				catch (Exception ex)
				{
					strReturn = date;
				}
			}

			return strReturn;
		}

		private string FindRoleValue(DataTable dtRole, string strOriginalValue)
		{
			string strReturn = strOriginalValue;

			int rowCount = dtRole?.Rows?.Count ?? 0;

			if (rowCount == 0)
			{
				return strReturn;
			}

			DataRow dr = dtRole.AsEnumerable().FirstOrDefault(x => String.Compare(StringHelper.SafeString(x["Item1"]), strOriginalValue, true) == 0);

			if (dr != null)
			{
				strReturn = StringHelper.SafeString(dr["Item2"]);
			}

			return strReturn;
		}

		private bool isGroup(string type)
		{ // 그룹의 경우 true, 아니면 false 
			return (type.Length < 1 || type.Substring(0, 1) != "u") ? true : false;
		}

		private string isEmpty(string s)
		{  //값이 공백 또는 스페이스만 들어 있을 경우 &nbsp; 로 대체
			return (s.Replace(" ", "") == "") ? "&nbsp;" : s;
		}

		private string replaceTextArea(string s)
		{
			return s.Replace("<", "&lt;").Replace(">", "&gt;").Replace("\n", "<br/>").Replace(" ", "&nbsp;");
		}

		private string encodeHtml(string s)
		{
			return replaceTextArea(isEmpty(s));
		}

		
	}
}