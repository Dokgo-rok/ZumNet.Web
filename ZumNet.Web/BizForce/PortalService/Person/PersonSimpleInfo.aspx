<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PersonSimpleInfo.aspx.cs" Inherits="ZumNet.Web.BizForce.PortalService.Person.PersonSimpleInfo" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
    <meta name="description" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <link rel="icon" type="image/x-icon" href="~/favicon.ico">

    <title>사용자 정보</title>

    <link href="/bundle/vendor/fonts?v=-4mQgRkxzRz_OGGBeJMlmalce3QX3z0u_yjps8Hd9JI1" rel="stylesheet">
    <link href="/bundle/vendor/css/bootstrap?v=Krt1QhVI1WLcflD2JRFv8t17KcrG5W1ToUKAROsxC4E1" rel="stylesheet">
    <link href="/bundle/vendor/css/csskit?v=xWclkiCiARz2E77q7N_hMq3sK1i18R8DntFuU2s3A8M1" rel="stylesheet">
    <link href="/bundle/css/site?v=6cACdtU8eUhUkSyz1IUiIeAIe-RIkYhRrIwpQ5XR1A81" rel="stylesheet">

    <style type="text/css">
        .modal-dialog .modal-header {
            background-color: rgba(76, 255, 0, 0.1);
            border-bottom-width: 2px;
        }
        .modal-body .table th {
            background-color: rgba(76, 255, 0, 0.1);
        }
        .modal-body .contact-content .contact-content-img {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="modal-dialog m-0">
        <div class="modal-content bg-white">
            <div class="modal-header">
                <h6 class="modal-title">사용자 세부 정보</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="window.close();">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body p-3">
                <% if (PersonInfo == null) { %>
                    <p class="mt-4 mb-5 fs-16 text-muted text-center"><%=Resources.Global.Auth_NoDB%></p>
                <% } else {  %>
                    <div class="media contact-content">
                        <%=GetOrgUserImage(PersonInfo["LogonID"].ToString()) %>
                        <div class="media-body">
                            <% if (PersonInfo["Description"].ToString() == "") { %>
                                <p class="text-primary pt-3 text-center">입력된 소개글이 없습니다.</p>
                            <% } else  { %>
                                <p class="pt-3 text-center"><%=PersonInfo["Description"]%></p>
                            <% } %>
                        </div>
                    </div>
                    <div style="height: 284px; overflow:auto">
                        <table class="table table-bordered mb-0">
                            <tr>
                                <th class="text-nowrap"><%=Resources.Global.Name%></th>
                                <td class=""><%=PersonInfo["UserName"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap"><%=Resources.Global.Department%></th>
                                <td class=""><%=PersonInfo["TeamName"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap"><%=Resources.Global.Jikwi%></th>
                                <td class=""><%=PersonInfo["Position"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap">담당업무</th>
                                <td class=""><%=PersonInfo["BusinessMain"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap">핸드폰</th>
                                <td class=""><%=PersonInfo["Mobile"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap">Mail</th>
                                <td class=""><%=PersonInfo["MainMail"]%></td>
                            </tr>
                            <tr>
                                <th class="text-nowrap">연락처</th>
                                <td class=""><%=PersonInfo["InterPhone"]%></td>
                            </tr>
                            <%if (PersonInfo["LogonID"].ToString() == "sjaekim") { %>
                                <tr>
                                    <th class="text-nowrap">생년월일</th>
                                    <td class=""><%=PersonInfo["Birthday"]%></td>
                                </tr>
                                <tr>
                                    <th class="text-nowrap">입사일</th>
                                    <td class=""><%=PersonInfo["Indate"]%></td>
                                </tr>
                                <tr>
                                    <th class="text-nowrap">최종학교</th>
                                    <td class=""><%=PersonInfo["SecondBusiness5"]%></td>
                                </tr>
                            <% } %>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

</body>
</html>