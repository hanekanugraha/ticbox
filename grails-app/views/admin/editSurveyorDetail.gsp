<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<%@ page import="ticbox.LookupMaster" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Surveyor Profile</title>
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
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title">Surveyor Profile</div>
        </div>

<div id="profileForm" class="module-content" >
    <g:form class="form-horizontal" action="updateSurveyorProfile">
        <!-- hiddens -->
        <div style="margin: 0;">

            <!-- static fields -->
            <div class="control-group" style="margin: 0;">
                <div class="profile-card">
                    <div class="profile-picture">
                        <g:if test="${user.pic}">
                            <a class="media-thumbnail" target="_blank"
                              data-url="${g.createLink(controller: 'survey', action: 'viewImage', params: [surveyorId: user.id])}"
                              data-resolved-url-large="${g.createLink(controller: 'survey', action: 'viewImage', params: [surveyorId: user.id])}"
                              href="${g.createLink(controller: 'survey', action: 'viewImage', params: [surveyorId: user.id])}" loaded="true">
                                <img id="profilePic" class="img-polaroid img-rounded profile-pic" src="data:image;base64,${user.pic}"/>
                            </a>
                        </g:if>
                        <g:else>
                            <span class="media-thumbnail">
                                <img id="profilePic" class="img-polaroid img-rounded profile-pic" src="${g.resource(dir: 'images/ticbox', file: 'anonymous.png')}"/>
                            </span>
                        </g:else>
                    </div>
                    <div class="uploader-button">
                        <uploader:uploader id="imageUploader" url="${[controller:'survey', action:'uploadImage']}" params="${[surveyorId: user.id]}">
                            <uploader:onComplete>
                                $('.profile-pic').attr('src', 'data:image;base64,' + responseJSON.img);
                                $('.qq-upload-list').empty()
                            </uploader:onComplete>
                        </uploader:uploader>
                    </div>
                </div>
            </div>

        </div>

        <div style="padding: 20px; background-color: #eeeeed; border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;" >

            <div class="form-group">
                <label class="col-sm-3 control-label" for="username"><g:message code="app.username.label"/></label>
                <div class="col-sm-8">
                    <g:textField class="form-control" name="username" value="${user.username}" disabled="disabled"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label" for="email"><g:message code="app.email.label"/></label>
                <div class="col-sm-8">
                    <g:textField class="form-control" name="email" value="${user.email}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label"><g:message code="app.password.label"/></label>
                <div class="col-sm-8">
                    <a href="#change-password-modal" role="button" class="btn btn-sm btn-light-oak" data-toggle="modal"><g:message code="app.change.label"/></a>
                </div>
            </div>
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
                <span id="myModalLabel" class="modal-title" ><g:message code="app.changepassword.label"/></span>
            </div>
            <div class="modal-body form-horizontal">
                <div class="form-group">
                    <label class="col-xs-4 control-label"><g:message code="app.oldpassword.label"/></label>
                    <div class="col-xs-7">
                        <g:hiddenField name="id" value="${user.id}"/>
                        <g:passwordField class="form-control" name="oldPassword" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-4 control-label"><g:message code="app.newpassword.label"/></label>
                    <div class="col-xs-7">
                        <g:passwordField class="form-control" name="newPassword" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-xs-4 control-label"><g:message code="app.confirmpassword.label"/></label>
                    <div class="col-xs-7">
                        <g:passwordField class="form-control" name="confirmPassword" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close"/></button>
                <button id="change-password-button" class="btn btn-default btn-green"><g:message code="app.savechanges.label"/></button>
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