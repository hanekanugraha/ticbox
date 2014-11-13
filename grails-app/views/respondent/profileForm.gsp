<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 4/13/13
  Time: 8:53 PM
--%>

<%@ page import="ticbox.City; ticbox.LookupMaster" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="respondent"/>
    <title>Respondent Profile Form</title>
    <r:require module="fileuploader" />
    <style type="text/css">
        .profile-card {
            background-image: url("../images/skin/bg_tumblr_grey.jpg");
            position: relative;
            /*margin: 10px 0 20px;*/
            /*box-shadow: 1px 1px 5px lightgrey;*/
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }

        .profile-picture {
            display: table;
            margin:auto;
            padding-top: 20px;
        }

        .profile-card .uploader-button {
            display: table;
            margin: auto;
            padding-top: 10px;
            width: 100%;
            text-align: center;
        }

        .qq-upload-button {
            margin: auto;
        }

        .qq-upload-button, .qq-upload-button input[type="file"] {
            border-bottom: none !important;
            -webkit-border-radius: 15px;
            -moz-border-radius: 15px;
            border-radius: 15px;
            background-color: #56400A !important;
            background-image: -moz-linear-gradient(top, #916C0E, #56400A) !important;
            background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#916C0E), to(#56400A)) !important;
            background-image: -webkit-linear-gradient(top, #916C0E, #56400A) !important;
            background-image: -o-linear-gradient(top, #916C0E, #56400A) !important;
            background-image: linear-gradient(to bottom, #916C0E, #56400A) !important;
            box-shadow: 0 12px 3px 0 rgba(255, 255, 255, 0.16) inset, 0 1px 2px rgba(0, 0, 0, 0.25);
            border: none !important;
            padding: 5px 5px 8px !important;
        }

        .qq-upload-button-hover {
            background-color: #56400A;
        }

        #profilePic {
            width: auto;
            max-height: 150px;
        }

    </style>
</head>
<body>
<div id="profileHeader" class="module-header">
    <div class="title">Respondent Profile</div>
</div>
<div id="profileForm" class="module-content" >
    <g:form class="form-horizontal" action="modify" name="respProfileForm">
        <!-- hiddens -->
        <g:hiddenField name="id" value="${respondent.id}"/>

        <div style="margin: 0;">

            <!-- static fields -->
            <div class="control-group" style="margin: 0;">
                <div class="profile-card">
                    <div class="profile-picture">
                        <g:if test="${respondent.pic}">
                            <a class="media-thumbnail" target="_blank" data-url="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" data-resolved-url-large="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" href="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" loaded="true">
                                <img id="profilePic" class="img-polaroid img-rounded" src="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}"/>
                            </a>
                        </g:if>
                        <g:else>
                            <a class="media-thumbnail" target="_blank" data-url="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" data-resolved-url-large="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" href="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}" loaded="true">
                                <img id="profilePicAnonymous" class="img-polaroid img-rounded" src="${g.resource(dir: 'images/ticbox', file: 'anonymous.png')}"/>
                            </a>
                        </g:else>
                    </div>
                    <div class="uploader-button">
                        <uploader:uploader id="imageUploader" url="${[controller:'respondent', action:'uploadImage']}" params="${[respondentId: respondent.id]}">
                            <uploader:onComplete>
                                $('.profilePic').attr('src', '${g.createLink(action: "viewImage", params: [respondentId: respondent.id])}&u='+new Date().getTime());
                            </uploader:onComplete>
                        </uploader:uploader>
                    </div>
                </div>
            </div>

        </div>

        <div style="padding: 20px; background-color: #eeeeed; border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;" >

            <div class="form-group">
                <label class="col-sm-3 control-label" for="username">Username</label>
                <div class="col-sm-8">
                    <g:textField class="form-control" name="username" value="${respondent.username}" disabled="disabled"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="email">E-Mail</label>
                <div class="col-sm-8">
                    <g:textField class="form-control" name="email" value="${respondent.email}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Password</label>
                <div class="col-sm-8">
                    <a href="#change-password-modal" role="button" class="btn btn-sm btn-light-oak" data-toggle="modal">Change</a>
                </div>
            </div>

            <hr />

            <!-- dynamic fields -->
            <g:each in="${profileItems}" var="profileItem">
                <div class="form-group">
                    <label class="col-sm-3 control-label">
                        ${profileItem.label}
                        <g:if test="${profileItem.unit}">
                            (${profileItem.unit})
                        </g:if>
                    </label>
                    <div class="col-sm-8">
                        <g:if test="${profileItem.type == ticbox.ProfileItem.TYPES.STRING}">
                            <g:if test="${profileItem.row > 1}">
                                <g:textArea name="${profileItem.code}" class="form-control" rows="${profileItem.row}" cols="30" maxlength="${profileItem.max}" placeholder="${profileItem.placeHolder}">${respondentDetail?.profileItems[profileItem.code]}</g:textArea>
                            </g:if>
                            <g:else>
                                <input name="${profileItem.code}" type="text" class="form-control" maxlength="${profileItem.max}" placeholder="${profileItem.placeHolder}" value="${respondentDetail?.profileItems[profileItem.code]}"/>
                            </g:else>
                        </g:if>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.DATE}">
                            <input name="${profileItem.code}" type="text" class="datePicker form-control" style="width: auto" placeholder="${message([code: 'app.date.format.input', default: 'dd/MM/yyyy'])}" value="${g.formatDate(format: g.message(code: 'app.date.format.input', default: 'dd/MM/yyyy'), date: respondentDetail?.profileItems[profileItem.code])}" />
                        </g:elseif>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.NUMBER}">
                            <input name="${profileItem.code}" type="text" placeholder="${profileItem.min && profileItem.max ? "${profileItem.min} - ${profileItem.max}" : ''}" value="${respondentDetail?.profileItems[profileItem.code]}" class="num form-control" data-max="${profileItem.max}" data-min="${profileItem.min}" style="text-align:right">
                        </g:elseif>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.LOOKUP}">
                            <g:select name="${profileItem.code}" class="form-control" style="width: auto" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" value="${respondentDetail?.profileItems[profileItem.code]}"/>
                        </g:elseif>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.CHOICE}">

                            <g:if test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.CHK_BOX}">
                                <g:if test="${profileItem.items}">
                                    <g:each in="${profileItem.items}" var="item">
                                        <label class="checkbox" style="font-weight: normal">
                                            <input type="checkbox" name="${profileItem.code}" value="${item}" <g:if test="${respondentDetail?.profileItems[profileItem.code]?.contains(item)}">checked</g:if> /> ${"$item"}
                                        </label>
                                    </g:each>
                                </g:if>
                                <g:elseif test="${profileItem.lookupFrom}">
                                    <g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">
                                        <label class="checkbox" style="font-weight: normal">
                                            <input type="checkbox" name="${profileItem.code}" value="${item.key}" <g:if test="${respondentDetail?.profileItems[profileItem.code]?.contains(item.key)}">checked</g:if> /> ${"$item.value"}
                                        </label>
                                    </g:each>
                                </g:elseif>
                            </g:if>

                            <g:elseif test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.SELECT}">
                                <g:if test="${profileItem.items}">
                                    <g:if test="${profileItem.multiple}">
                                        <g:select class="form-control" style="width: auto" name="${profileItem.code}" from="${profileItem.items}"  multiple="true"  value="${respondentDetail?.profileItems[profileItem.code]?.toList()}" />
                                    </g:if>
                                    <g:else> %{--this is stupid!!!!--}%
                                        <g:select class="form-control" style="width: auto" name="${profileItem.code}" from="${profileItem.items}" value="${respondentDetail?.profileItems[profileItem.code]}" />
                                    </g:else>
                                </g:if>
                                <g:elseif test="${profileItem.lookupFrom}">
                                    <g:if test="${profileItem.multiple}">
                                        <g:select class="form-control" style="width: auto" name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" multiple="true" value="${respondentDetail?.profileItems[profileItem.code]?.toList()}"/>
                                    </g:if>
                                    <g:else> %{--this is stupid!!!!--}%
                                        <g:if test="${profileItem.code=="PI_PROVINCE001"}" >
                                            <g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;" onchange="changeIt(this)" value="${respondentDetail?.profileItems[profileItem.code]}"/>
                                        </g:if>
                                        <g:elseif test="${profileItem.code=="PI_CITY001"}" >
                                            <g:select name="${profileItem.code}" from="${City.findAllByParent(respondentDetail.getProfileItems().get('PI_PROVINCE001'))}" optionKey="code" optionValue="label" class="form-control" style="min-width: 40%; width: auto;" value="${respondentDetail?.profileItems[profileItem.code]}"/>
                                        </g:elseif>
                                        <g:else>
                                            <g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;" value="${respondentDetail?.profileItems[profileItem.code]}"/>
                                        </g:else>
                                    </g:else>
                                </g:elseif>
                            </g:elseif>

                            <g:elseif test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.RADIO}">
                                <g:if test="${profileItem.items}">
                                    <g:each in="${profileItem.items}" var="item">
                                        <label class="radio" style="font-weight: normal">
                                            <input type="radio" name="${profileItem.code}" value="${item}" <g:if test="${item.equals(respondentDetail?.profileItems[profileItem.code])}">checked</g:if> /> ${"$item"}
                                        </label>
                                    </g:each>
                                </g:if>
                                <g:elseif test="${profileItem.lookupFrom}">
                                    <g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">
                                        <label class="radio" style="font-weight: normal">
                                            <input type="radio" name="${profileItem.code}" value="${item.key}" <g:if test="${item.key.equals(respondentDetail?.profileItems[profileItem.code])}">checked</g:if> /> ${"$item.value"}
                                        </label>
                                    </g:each>
                                </g:elseif>
                            </g:elseif>

                        </g:elseif>
                    </div>
                </div>
            </g:each>

        </div>

        <!-- action buttons -->
        <g:submitButton name="submit" value="${g.message(code:'app.submit.label')}" class="btn btn-lg btn-green" style="margin: 15px 0"/>

    </g:form>
</div>

<!-- Change password modal -->
<div id="change-password-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="myModalLabel" class="modal-title" >Change Password</span>
            </div>
            <div class="modal-body form-horizontal">
                <div class="form-group">
                    <label class="col-xs-4 control-label">Old Password</label>
                    <div class="col-xs-7">
                        <g:hiddenField name="id" value="${respondent.id}"/>
                        <g:passwordField class="form-control" name="oldPassword" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-4 control-label">New Password</label>
                    <div class="col-xs-7">
                        <g:passwordField class="form-control" name="newPassword" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-4 control-label">Confirm Password</label>
                    <div class="col-xs-7">
                        <g:passwordField class="form-control" name="confirmPassword" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default btn-light-oak" data-dismiss="modal" aria-hidden="true">Close</button>
                <button id="change-password-button" class="btn btn-default btn-green">Save changes</button>
            </div>
        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">

    /* Change password modal trigger */
    $('#change-password-button').click(function() {
        var url = '${g.createLink(controller: "auth", action: "changePassword")}';
        var data = $('#change-password-modal').find('input').serialize();
        $.post(url, data, function(response) {
            var message = (response) ? response.message : 'Application error';
            $('#change-password-modal').modal('hide');
            alert(message);
        });
    });

    /* Change password modal on close */
    $('#change-password-modal').on('hide', function() {
        $('#change-password-modal').find('input[type="password"]').val('');
    });

    $(document).ready(function() {


        $('#respProfileForm').validate({
            rules: {
                email: {
                    email: true,
                    required: true,
                    minlength: 5
                }
            }
        });

        $('.num').each(function() {
            $(this).rules('add', {
                number: true,
                range: [$(this).attr('data-min'), $(this).attr('data-max')]
            });
        });

        $('.datePicker').each(function() {
            $(this).rules('add', {
                dateITA: true
            });
        });

    });

    function changeIt(selectObj) {
        var val = selectObj.options[selectObj.selectedIndex].value;
        var elmtCity= $('#PI_CITY001')
        if(elmtCity) {
            elmtCity.find('option').remove().end();
            jQuery.getJSON('${request.contextPath}/home/getCity', {province: val}, function (cities) {
//                var temp = cities;
                jQuery.each(cities, function (i, item) {
                    var option = document.createElement("option");
                    option.text = item.label;
                    option.value = item.code;
                    elmtCity.append(option);
                });
            });
        }
//                                            }

    }
    function loadIt() {

        var elmtProvince=document.getElementById("PI_PROVINCE001");
        var val = elmtProvince.options[elmtProvince.selectedIndex].value;
        var elmtCity= $('#PI_CITY001')
        if(elmtCity) {
            elmtCity.find('option').remove().end();
            jQuery.getJSON('${request.contextPath}/home/getCity', {province: val}, function (cities) {

                jQuery.each(cities, function (i, item) {
                    var option = document.createElement("option");
                    option.text = item.label;
                    option.value = item.code;

                    elmtCity.append(option);
                });
            });
        }

    }

</script>

</body>
</html>