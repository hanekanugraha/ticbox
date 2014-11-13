<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 11/13/2014
  Time: 5:39 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="ticbox">
    <title>Change Password</title>

</head>

<body>
<div class="modal-content">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <span id="myModalLabel" class="modal-title" >Change Password</span>
    </div>
    <div class="modal-body form-horizontal">
        <g:form class="form-horizontal" controller="auth" action="resetPassword" name="respProfileForm">
            <g:hiddenField name="id" value="${user.id}"/>
            <g:hiddenField name="resetPassword" value="${user.resetPassword}"/>

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
            <g:submitButton name="submit" value="${g.message(code:'app.submit.label')}" class="btn btn-lg btn-green" style="margin: 15px 0"/>

        </g:form>

    </div>


</body>
</html>